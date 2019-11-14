% Local Feature Stencil Code
 
% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, feature_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each feature_width/4.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one. This is not required,
% though.

% Placeholder that you can delete. Empty features.
features=[];



%Indexes for bins of histogram
pos_x=1;
pos_y=2;
neg_x=3;
neg_y=4;
pos_x_pos_y=5;
pos_x_neg_y=6;
neg_x_pos_y=7;
neg_x_neg_y=8;

%Size of window
padrow=7;
padcol=8;

for i=1:size(x,1)
    row1=abs(x(i,1)-padrow);
    row2=abs (x(i,1)+padcol);
    col1= abs(y(i,1)-padrow);
    col2=abs(y(i,1)+padcol);
    
    if(gt(row1,1) & ~gt(row2,size(image,1)) & gt(col1,1)& ~gt(col2,size(image,2)) )
        %16X16 histogram block
        temp_cell= image(row1:row1+15, col1:col1+15);
        H_keypoint=[];
        for j=1:4
            indexj= j*4;
            for k=1:4
                histogram= zeros(1,8);
                index= k*4;
                % 4X4 histogram cell.
                temp= temp_cell(indexj-3:indexj , index-3:index);
                % Calculate the gradient for each cell.
                [x_gradient,y_gradient] = gradient(temp);
                diag_gradient= x_gradient+y_gradient;
                for g=1:size(temp,1)
                    for h=1:size(temp,2)
              
                        if x_gradient(g,h) >= 0
                            % x and y positive
                            if y_gradient(g,h) >= 0
                                histogram(pos_y) = histogram(pos_y) + y_gradient(g,h);
                                histogram(pos_x) = histogram(pos_x) + x_gradient(g,h);
                                histogram(pos_x_pos_y) = histogram(pos_x_pos_y) + diag_gradient(g,h);
                            % x positive, y negative
                            else
                                 histogram(neg_y) = histogram(neg_y) + y_gradient(g,h);
                                 histogram(pos_x) = histogram(pos_x) + x_gradient(g,h);
                                 histogram(pos_x_neg_y) = histogram(pos_x_neg_y) + diag_gradient(g,h);                                
                            end
                        else
                          % x negative, y positive
                             if y_gradient(g,h) >= 0
                                histogram(pos_y) = histogram(pos_y) + y_gradient(g,h);
                                histogram(neg_x) = histogram(neg_x) + x_gradient(g,h);
                                histogram(neg_x_pos_y) = histogram(neg_x_pos_y) + diag_gradient(g,h);
                          % both negative
                             else
                                 histogram(neg_y) = histogram(neg_y) + y_gradient(g,h);
                                 histogram(neg_x) = histogram(neg_x) + x_gradient(g,h);
                                 histogram(neg_x_neg_y) = histogram(neg_x_neg_y) + diag_gradient(g,h);
                             end
                        end
                
                    end
                end
             H_keypoint= cat(2,H_keypoint,histogram); 

            end
        end
    features = cat(1,features,H_keypoint);
    end 
features = features / norm(features);     
end
