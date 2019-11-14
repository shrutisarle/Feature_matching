% Local Feature Stencil Code

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or(b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% Placeholder that you can delete. 20 random points
x = ceil(rand(20,1) * size(image,2));
y = ceil(rand(20,1) * size(image,1));

radius=1;
order= (2*radius+1);
threshold=0.07;
%coverting image to double
im = double(image);

%  Compute the horizontal and vertical derivatives of the image Ix and 
%  Iy by convolving the original image 
% Compute derivatives of image
[dx,dy]= meshgrid(-1:1,-1:1);
Ix = conv2(im, dx, 'same');
Iy = conv2(im, dy, 'same');

%Compute the three images corresponding to the outer products of these 
%gradients and Convolve each of these images with a larger Gaussian.
g = fspecial('gaussian');
Ix2 = conv2(Ix .^ 2, g, 'same');
Iy2 = conv2(Iy .^ 2, g, 'same');
Ixy = conv2(Ix .* Iy, g, 'same');

% Harris corner measure
alpha = .04;
M_det = Ix2.*Iy2 - Ixy.^2;
M_tr = Ix2 + Iy2;
cornerness = M_det - alpha*(M_tr).^2;

% Find local maxima (non maximum suppression)
mx = ordfilt2(cornerness, order^ 2, ones(order));

% Thresholding
harris_points =(cornerness==mx) &(cornerness > threshold);

[row, col]= find(harris_points);
y = row;
x = col;

end