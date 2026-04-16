% prob10_7.m - Pick the largest lake
% Marquette University
% Fred J. Frigo, Ph.D.
%
% See Digital Image Processing, 4th edition
% Read the image, save the black and gray color values
A = imread('gray-lakes.tif');
black = min(min(A));
gray = max(max(A));
% Show image to find interior points for each lake
figure;
imshow(A); title('Original Image'); drawnow;
% top right lake
top_right_mask = grayconnected(A, 150, 350);
top_right_sum = sum(top_right_mask,'All');
top_right_title = sprintf('Top Right Lake = %d pixels', top_right_sum);
figure;
imshow(top_right_mask); title( top_right_title); drawnow;
% bottom right lake
bot_right_mask = grayconnected(A, 450, 400);
bot_right_sum = sum(bot_right_mask, 'All');
bot_right_title = sprintf('Bottom Right Lake = %d pixels', bot_right_sum);
figure;
imshow(bot_right_mask); title(bot_right_title); drawnow;
% bottom left lake
bot_left_mask = grayconnected(A, 400, 100);
bot_left_sum = sum(bot_left_mask,'All');
bot_left_title = sprintf('Bottom Left Lake = %d pixels', bot_left_sum);
figure;
imshow(bot_left_mask); title(bot_left_title); drawnow;
% Create new image with just the largest lake preserving shades of gray
black_image = uint8(top_right_mask).*black;
gray_image = uint8(imcomplement(top_right_mask)).*gray;
final_image = black_image + gray_image;
figure;
imshow(final_image); title('Largest Lake'); drawnow;
