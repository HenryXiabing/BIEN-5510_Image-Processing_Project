%% Recon_1024_NoGradwarp.m
% 1024x1024 MR reconstruction of DQA3 without Gradwarp


%% --- Select Pfile ---
pfile = "";
if(pfile == "")
    [fname, pname] = uigetfile('*.*', 'Select Pfile');
    pfile = strcat(pname, fname);
end
slice_no = 6;        % DQA3 has 1 slice

%% --- 1: Read raw data ---
[raw_data, chop, da_xres, da_yres, gw_coil, corner_points] = getChannelData(pfile, slice_no);
num_chan = size(raw_data,3);

%% --- 2: Fermi apodization ---
xdim = size(raw_data, 1);
ffilter = fermi(xdim, 0.45*xdim, 0.1*xdim);
filt_data = filterChannelData(raw_data, ffilter, chop, num_chan);

%% --- 3: Zero padding by factor of 4 for 1024x1024 ---
zip_factor = 4;
[dayres, daxres, ~] = size(filt_data);
ZP_data = zeros(dayres*zip_factor, daxres*zip_factor, num_chan);
ZP_data(1:dayres,1:daxres,:) = filt_data;

%% --- 4: Display K-space magnitude ---
displayMagnitude(ZP_data, 'K-space log-magnitude', 1);

%% --- 5: Transform to image domain ---
im_data = transformChannelData(ZP_data);

%% --- 6: Sum-of-squares ---
if num_chan > 1
    weights = read_weights(pfile);
else
    weights = 1.0;
end
sos_image = sumOfSquares(im_data, weights);

%% --- 7: Resize image ---
mag_image = resize_image(sos_image, da_xres, da_yres, zip_factor);

%% --- 8: Skip Gradwarp ---
gw_image = mag_image;  % No Gradwarp applied

%% --- 9: Scale & display ---
scale_factor = 20000 / max(gw_image(:));
final_image = uint16(gw_image * scale_factor);
figure; imshow(final_image, []);
title('1024x1024 DQA3 No Gradwarp');

%% --- 10: Save DICOM ---
new_dfile = strcat(pfile, '_1024_NoGradwarp.dcm');
dicomwrite(final_image, new_dfile);
info = dicominfo(new_dfile);
info.WindowWidth  = max(final_image(:));
info.WindowCenter = info.WindowWidth/2;
info.PatientName.FamilyName = 'DQA3';
info.SeriesDescription = '1024x1024 No Gradwarp';
dicomwrite(final_image, new_dfile, info, 'CreateMode', 'copy');
disp(['DICOM file created: ', new_dfile]);