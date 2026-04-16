% Load the image
A_gray = imread('prob9_23.jpg');

% Convert to binary image (A)
% Morphology functions expect white (1) as the foreground
% We use imbinarize to create the binary set A
A = imbinarize(A_gray); 

% Define the disk structuring element B with radius 20
B = strel('disk', 20);

% B) C = A eroded by B
C = imerode(A, B);

% C) D = C dilated by B (This completes the 'Opening' of A)
D = imdilate(C, B);

% D) E = D dilated by B
E = imdilate(D, B);

% E) F = E eroded by B (This completes the 'Closing' of D)
F = imerode(E, B);

% --- Display Results ---
figure('Name', 'Morphological Operations', 'NumberTitle', 'off');

subplot(2,3,1); imshow(A_gray); title('A) Input Grayscale');
subplot(2,3,2); imshow(C); title('B) C = A \ominus B');
subplot(2,3,3); imshow(D); title('C) D = C \circ B (Opening)');
subplot(2,3,4); imshow(E); title('D) E = D \oplus B');
subplot(2,3,5); imshow(F); title('E) F = E \bullet B (Closing)');

% Maximize figure window for better viewing
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
