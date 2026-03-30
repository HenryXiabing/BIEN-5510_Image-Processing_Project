%% Recon_512_Gradwarp.m
% 512x512 MR reconstruction of Pfile with Gradwarp
% Marquette University style
% Updated 2026-03-29 by Henry Xia

%% --- Select Pfile ---
pfile = "";
if(pfile == "")
    [fname, pname] = uigetfile('*.*', 'Select Pfile');
    pfile = strcat(pname, fname);
end

slice_no = 6;   % specify slice number if multiple slices are present

%% --- 1: Read raw data ---
[raw_data, chop, da_xres, da_yres, gw_coil, corner_points] = getChannelData(pfile, slice_no);
num_chan = size(raw_data,3);
fprintf('Number of channels = %d, using slice %d\n', num_chan, slice_no);

%% --- 2: Fermi apodization ---
xdim = size(raw_data, 1);
ffilter = fermi(xdim, 0.45*xdim, 0.1*xdim);
filt_data = filterChannelData(raw_data, ffilter, chop, num_chan);

%% --- 3: Display K-space magnitude ---
displayMagnitude(raw_data, 'K-space log-magnitude', 1);

%% --- 4: Transform to image domain ---
im_data = transformChannelData(filt_data);

%% --- 5: Display image magnitude per channel ---
displayMagnitude(im_data, 'Image magnitude', 0);

%% --- 6: Sum-of-squares magnitude ---
if (num_chan > 1)
    weights = read_weights(pfile);
else
    weights = 1.0;
end
sos_image = sumOfSquares(im_data, weights);

%% --- 7: Resize to 512x512 ---
zip_factor = 2;  % 256 -> 512
% 使用 MATLAB 内置 imresize，避免索引错误
mag_image = imresize(sos_image, zip_factor, 'bilinear');

%% --- 8: Gradwarp correction ---
gw_coeffs = read_ge_coeff(gw_coil);
gw_image = gradwarp_2D(mag_image, gw_coeffs, corner_points);

%% --- 9: Scale image to max pixel 20000 ---
image_max = max(gw_image(:));
scale_factor = 20000 / image_max;
final_image = uint16(gw_image * scale_factor);

figure;
imshow(final_image, []);
title('Gradwarp Corrected 512x512');

%% --- 10: Save DICOM ---
new_dfile = strcat(pfile, '_512_Gradwarp.dcm');
dicomwrite(final_image, new_dfile);

info = dicominfo(new_dfile);
info.WindowWidth  = max(final_image(:));
info.WindowCenter = info.WindowWidth / 2;
info.PatientName.FamilyName = fname;
info.SeriesDescription = '512x512 Gradwarp Corrected';
info.ExamNumber = '1';
info.SeriesNumber = 1;
dicomwrite(final_image, new_dfile, info, 'CreateMode', 'copy');

disp(['DICOM file created: ', new_dfile]);

