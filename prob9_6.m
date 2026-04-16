% prob9_6.m -  JPEG image Compression
% Marquette University
% Fred J. Frigo, Ph.D.
% 
% Image Processing
% See Digital Image Processing with MATLAB, 3rd edition 
%


% Read the image
f = imread('vase.tif'); 
imwrite(f,'vase-40.jpg', 'quality', 40);
cr1 = imratio(f, 'vase-40.jpg');
fr1 = imread('vase-40.jpg');

c2 = im2jpeg(f, 1.25); 
cr2 = imratio( f, c2);
fr2 = jpeg2im(c2);

disp(['The im2jpeg was ' num2str(cr2),  ' compared to ', ...
    num2str(cr1), ' for the JPEG standard.']);

figure;
subplot(1,2,1); imshow(fr2);
xlabel('jpeg2im');
subplot(1,2,2); imshow(fr1);
xlabel ('JPEG Standard');

e1 = compare(f, fr1, 0);
e2 = compare(f, fr2, 0);

disp(['The img2jpeg RMSE = ', num2str(e2), ' The JPEG standard = ', num2str(e1)]);



