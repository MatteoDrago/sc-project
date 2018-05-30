function [cb, new_idx] = LBG(img, cb, coded_img, epsilon, gain)
%   LBG Linde-Buzo-Gray algorithm implementation
%   Detailed explanation goes here

flag = true;
cb_size = size(cb,1);
dst = distortion(img, cb(1:cb_size/2,:), coded_img);

% First assegnation for the new cluster centers
for i=(cb_size/2+1):cb_size 
    temp_dist = sum((cb(i,:)-img).^2,2).^0.5; %evaluate distortion
    toChange = temp_dist./dst < gain; % find occurrences that need to be changed
    coded_img(toChange,:) = i; % assig   
end

% Update the number of points assigned to each cluster and check if there's
% any empty clusters
[counter, anyEmpty, empty_clt] = checkAnyEmptyClt(coded_img);

c = 0;
while flag
    
    while anyEmpty

        [~, max_i] = max(counter);
        candidates = img(coded_img == max_i,:);
        cb(empty_clt,:) = candidates(randi(size(candidates,1)),:);

        temp_dist = sum((cb(empty_clt,:)-img).^2,2).^0.5; %evaluate distortion
        toChange = temp_dist./dst < 0.3; % find occurrences that need to be changed
        coded_img(toChange,:) = empty_clt;   
        [counter, anyEmpty, empty_clt] = checkAnyEmptyClt(coded_img);
        c = c + 1;
    end
    
    % Now I take as codewords the centroid of the clusters
    for i=1:size(cb,1)
        cb(i,1) = mean(img(coded_img == i,1));
        cb(i,2) = mean(img(coded_img == i,2));
        cb(i,3) = mean(img(coded_img == i,3));
    end

    new_dst = distortion(img, cb, coded_img); % evaluate new value for the distortion 
    before = mean(dst);
    after = mean(new_dst);
    progress = (after - before)/after;

    if progress < epsilon
        flag = false;
    else
        dst = new_dst;
        for i=1:cb_size 
            temp_dist = sum((cb(i,:)-img).^2,2).^0.5; %evaluate distortion
            toChange = temp_dist < dst; % find occurrences that need to be changed
            coded_img(toChange,:) = i; % assig   
        end
        [counter, anyEmpty, empty_clt] = checkAnyEmptyClt(coded_img, cb_size);
    end
end
fprintf('Loop run %d times \n', c);

new_idx = coded_img;
end

