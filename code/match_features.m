% Local Feature Stencil Code


% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features 1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% For extra credit you can implement various forms of spatial verification of matches.


% 
%< Placeholder that you can delete. Random matches and confidences
%pleae detect this following paragraph and implement your own codes; 
%'matches':and 'confidences' according to the
%near neighbor based matching algorithm. 

%     num_features1 = size(features1, 1);
%     num_features2 = size(features2, 1);
%     matches = zeros(num_features1, 2);
%     matches(:,1) = randperm(num_features1);
%     matches(:,2) = randperm(num_features2);
%     confidences = rand(num_features1,1);
%> 

% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.

thresholdValue = 0.9;
% Find the euclidean distance between the features of both images.
distantMatches = pdist2(features1, features2, 'euclidean');
% sort all of the matches.
[sorted_distantMatches, indices] = sort(distantMatches, 2);
% Calculate the confidence of the matches.
invConfidence = (sorted_distantMatches(:,1)./sorted_distantMatches(:,2));
confidences = 1./invConfidence(invConfidence < thresholdValue);
matches = zeros(size(confidences,1), 2);
matches(:,1) = find(invConfidence < thresholdValue);
matches(:,2) = indices(invConfidence < thresholdValue, 1);
[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);

end