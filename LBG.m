function [cb, new_idx] = LBG(img, cb, dst, idx, epsilon)
%   LBG Linde-Buzo-Gray algorithm implementation
%   Detailed explanation goes here

flag = true;
   
%% FIRST EVALUATION

% recompute the codewords as the mean of training vecotrs assigned to a
% signle quantization value
% 
% for i=1:size(cb,1)
%     cb(i,:) = round(mean(img(idx == i)));
% end
% 
% new_dst = distortion(img,cb,idx); % evaluate new value for the distortion
% 
% Evaluate the gain obtained changing the codebook 
% before = mean(dst);
% after = mean(new_dst);
% progress = (after - before)/after;
% 
% if progress < epsilon
%     flag = false;
% end

%% CODEBOOK OPTIMIZATION
% If it provides additional gain, reassign training vectors to the new
% codewords and iterates the first evaluation procedure until no more gain
% can be obtained

while flag
    
    for i = 1:size(cb,1)
        empty_clt = true;
        temp_dist = sum((cb(i,:)-img).^2,2).^0.5;
        toChange = temp_dist < dst;
        idx(toChange,:) = i; % this corresponds to assing one quantization value to a single training vector 
        while empty_clt
            clt = checkAnyEmptyClt(idx,size(cb,1)); % check if there's any empty cluster
            if clt == 0
                empty_clt = false;
            else
                % we need to reassign the codeword in order to avoid empty
                % cluster
                cb(clt,:) = reassignCodeword(img, idx, size(cb,1));
                temp_dist = sum((cb(clt,:)-img).^2,2).^0.5;
                toChange = temp_dist < dst;
                idx(toChange,:) = clt;
            end
        end
    end
    
    for i=1:size(cb,1)
        cb(i,1) = mean(img(idx == i,1));
        cb(i,2) = mean(img(idx == i,2));
        cb(i,3) = mean(img(idx == i,3));
    end

    new_dst = distortion(img, cb, dst); % evaluate new value for the distortion

    % Evaluate the gain obtained changing the codebook 
    before = mean(dst);
    after = mean(new_dst);
    progress = (after - before)/after;

    if progress < epsilon
        flag = false;
    end
    dst = new_dst;
end

new_idx = idx;
end

