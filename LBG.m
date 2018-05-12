function [cb, new_idx] = LBG(img, cb, dist, idx, epsilon)
%   LBG Linde-Buzo-Gray algorithm implementation
%   Detailed explanation goes here

flag = true;
   
%% FIRST EVALUATION

% recompute the codewords as the mean of training vecotrs assigned to a
% signle quantization value

for i=1:size(cb,1)
    cb(i,:) = round(mean(img(idx == i)));
end

new_dist = distortion(cb,img,dist,idx); % evaluate new value for the distortion

% Evaluate the gain obtained changing the codebook 
before = mean(dist);
after = mean(new_dist);
progress = (after - before)/after;

if progress < epsilon
    flag = false;
end

%% CODEBOOK OPTIMIZATION
% If it provides additional gain, reassign training vectors to the new
% codewords and iterates the first evaluation procedure until no more gain
% can be obtained

while flag
    dist = new_dist;
    for i = 1:size(cb,1)
        temp_dist(values,:) = sum((cb(i,:)-img).^2,2).^0.5;
        toChange = temp_dist < dist;
        idx(toChange,:) = i; % this corresponds to assing one quantization value to a single training vector 
    end
    
    for i=1:size(cb,1)
        cb(i,:) = round(mean(img(idx == i)));
    end

    new_dist = distortion(cb,img,dist,idx); % evaluate new value for the distortion

    % Evaluate the gain obtained changing the codebook 
    before = mean(dist);
    after = mean(new_dist);
    progress = (after - before)/after;

    if progress < epsilon
        flag = false;
    end
end

new_idx = idx;
end

