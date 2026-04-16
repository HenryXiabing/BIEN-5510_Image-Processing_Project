% prob9_5.m -  JPEG image Compression
% Marquette University
% Fred J. Frigo, Ph.D.
% 
% Image Processing
%
% The file 'tracy.tif' is used for this problem since the 
% image size of 'brushes.tif' (700x350) causes an error with im2jpeg()
%
% See Digital Image Processing with MATLAB, 3rd edition 
%

% Read the image
%f = imread('brushes.tif');
f = imread('tracy.tif');
q = quantize(f, 4,'igs');
qs = double(q)/16;
e = mat2lpc(qs);
c1 = mat2huff(e);
cr1 = imratio(f, c1);
ne = huff2mat(c1);
nqs = lpc2mat(ne);
fr1 = 16*nqs;

c2 = im2jpeg(f, 1);
cr2 = imratio(f, c2);
fr2 = jpeg2im(c2);

disp(['The JPEG compression was ', num2str(cr2), ' compared to ', ...
    num2str(cr1), ' for quantized verison']);

e1 = compare(f, fr1, 0);
e2 = compare(f, fr2, 0);


disp(['The JPEG RMSE = ', num2str(e2), ' the quantized RMSE = ', num2str(e1)]);

figure;
subplot(1,2,1); imshow(fr1, []);
xlabel('IGS + Huffman');
subplot(1,2,2); imshow(fr2, []);
xlabel('im2jpeg');

