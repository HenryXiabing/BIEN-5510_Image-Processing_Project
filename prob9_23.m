input_image = imread("prob9_23.jpg");
figure; imagesc(input_image);colormap('gray'); title("input image"); drawnow;
% Determine disk radius of structure element by enlarging input image
% Element B at lower right hand corner has a radius of 20
disk_radius = 20;
struct_element = strel('disk', disk_radius, 0);
c = imerode(input_image, struct_element);
d = imdilate( c, struct_element);
e = imdilate( d, struct_element);
f = imerode( e, struct_element); drawnow;
% show results
figure; imshow(c); title("image C"); drawnow;
figure; imshow(d); title("image D"); drawnow;
figure; imshow(e); title("image E"); drawnow;
figure; imshow(f); title("image F"); drawnow;
