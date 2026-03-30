%% Recon_2048_NoGradwarp.m
% 2048x2048 MR reconstruction of DQA3 without Gradwarp
% Updated 2026-03-29 by Henry Xia

%% --- Select Pfile ---
pfile = "";
if(pfile == "")
    [fname, pname] = uigetfile('*.*', 'Select Pfile');
    pfile = strcat(pname, fname);
end

slice_no = 6;  % adjust if needed

%% --- 1: Read raw data ---
[raw_data, chop, da_xres, da_yres, gw_coil, corner_points] = getChannelData(pfile, slice_no);
num_chan = size(raw_data,3);
fprintf('Number of channels = %d, using slice %d\n', num_chan, slice_no);

%% --- 2: Fermi apodization ---
xdim = size(raw_data, 1);
ffilter = fermi(xdim, 0.45*xdim, 0.1*xdim);
filt_data = filterChannelData(raw_data, ffilter, chop, num_chan);

%% --- 3: Zero padding by factor of 4 for 1024x1024 ---
zip_factor_small = 4;  % intermediate size
[dayres, daxres, ~] = size(filt_data);
ZP_data_small = zeros(dayres*zip_factor_small, daxres*zip_factor_small, num_chan);
ZP_data_small(1:dayres,1:daxres,:) = filt_data;

%% --- 4: Display K-space magnitude ---
displayMagnitude(ZP_data_small, 'K-space log-magnitude', 1);

%% --- 5: Transform to image domain ---
im_data = transformChannelData(ZP_data_small);

%% --- 6: Sum-of-squares ---
if num_chan > 1
    weights = read_weights(pfile);
else
    weights = 1.0;
end
sos_image = sumOfSquares(im_data, weights);

%% --- 7: Resize image to 1024x1024 safely ---
mag_image_small = imresize(sos_image, zip_factor_small, 'bilinear');

%% --- 8: Upsample to 2048x2048 (No Gradwarp) ---
zip_factor_final = 2;  % 1024 -> 2048
no_gw_image = imresize(mag_image_small, zip_factor_final, 'bilinear');

%% --- 9: Scale image and display ---
image_max = max(max(no_gw_image));
scale_factor = 20000 / image_max;
final_image = uint16(no_gw_image .* scale_factor);

figure();
imshow(final_image, []);
title("2048x2048 No Gradwarp");

%% --- 10: Save DICOM ---
new_dfile = strcat(pfile, '_2048_NoGradwarp.dcm');
dicomwrite(final_image, new_dfile);

info = dicominfo(new_dfile);
info.WindowWidth  = max(final_image(:));
info.WindowCenter = info.WindowWidth/2;
info.PatientName.FamilyName = 'DQA3';
info.SeriesDescription = '2048x2048 No Gradwarp';
info.ExamNumber = '1';
info.SeriesNumber = 1;
dicomwrite(final_image, new_dfile, info, 'CreateMode','copy');

disp(['DICOM file created: ', new_dfile]);

%% --- 11: Image differences (with color map) ---
% Use existing Gradwarp DICOM
gw_file = 'P20992.7_2048_Gradwarp.dcm';
if exist(gw_file,'file')
    gw_image = double(dicomread(gw_file));
    
    % Scale Gradwarp image to 20000
    image_max = max(gw_image(:));
    scale_factor = 20000 / image_max;
    gw_final_image = uint16(gw_image .* scale_factor);
    
    % Difference image
    diff_image = abs(double(gw_final_image) - double(final_image));
    
    % Display Gradwarp image
    figure;
    imshow(gw_final_image, []);
    title('Gradwarp 2048x2048');
    
    % Display difference image with color map
    figure;
    imagesc(diff_image);
    colormap(jet);   
    colorbar;         
    axis image;     
    title('Difference Image 2048x2048 (Color)');
end