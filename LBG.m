function [cb, new_idx] = LBG(img, cb, coded_img, epsilon, gain)

% initialization of useful variables
flag = true;
cb_size = size(cb,1);
dst = distortion(img, cb(1:cb_size/2,:), coded_img);

% First assegnation for the new cluster centers
for i=(cb_size/2+1):cb_size 
    temp_dist = sum((cb(i,:)-img).^2,2).^0.5; %evaluate distortion
    toChange = temp_dist./dst < gain; % find occurrences that need to be changed
    coded_img(toChange,:) = i; % assig   
end

plot3(cb(:,1),cb(:,2),cb(:,3),'ko','LineWidth',1.5);
grid on

% Update the number of points assigned to each cluster and check if there's
% any empty clusters
[counter, anyEmpty, empty_clt] = checkAnyEmptyClt(coded_img, cb_size);

c = 0;
while flag
    while anyEmpty
        % If there are any empty clusters, I evaluate the numerosity of clusters
        % in order to get the one more populated and I take some of its points to put
        % them on the empty cluster, in order to see if the situation improves
        [~, max_i] = max(counter);
        candidates = img(coded_img == max_i,:);
        cb(empty_clt,:) = candidates(randi(size(candidates,1)),:);

        temp_dist = sum((cb(empty_clt,:)-img).^2,2).^0.5; %evaluate distortion
        toChange = temp_dist./dst < gain; % find occurrences that need to be changed
        coded_img(toChange,:) = empty_clt; 
        [counter, anyEmpty, empty_clt] = checkAnyEmptyClt(coded_img, cb_size);
        c = c + 1;
        
        plot3(cb(:,1),cb(:,2),cb(:,3),'ko','LineWidth',1.5);
        grid on
        title(['Codebook size: ', num2str(cb_size) ,' Iteration number: ', num2str(c)])
        pause(0.1);% pause 2/10 second
        
    end
    
    % Update codebook
    for i=1:size(cb,1)
          cb(i,:) = mean(img(coded_img == i,:));
    end
    
    plot3(cb(:,1),cb(:,2),cb(:,3),'ko','LineWidth',1.5);
    grid on
    title(['Codebook size: ', num2str(cb_size) ,' Iteration number: ', num2str(c)])
    
    new_dst = distortion(img, cb, coded_img); % evaluate new value for the distortion 
    before = mean(dst);
    after = mean(new_dst);
    progress = (before - after)/after;
    
    if progress < epsilon
        flag = false;
    else
        dst = new_dst;
        for i=1:cb_size 
            temp_dist = sum((cb(i,:)-img).^2,2).^0.5; %evaluate distortion
            toChange = temp_dist./dst < gain; % find occurrences that need to be changed
            coded_img(toChange,:) = i;
        end
        [counter, anyEmpty, empty_clt] = checkAnyEmptyClt(coded_img, cb_size);
        c = c + 1;
        plot3(cb(:,1),cb(:,2),cb(:,3),'ko','LineWidth',1.5);
        grid on
        title(['Codebook size: ', num2str(cb_size) ,' Iteration number: ', num2str(c)])
        pause(0.01)
    end
end
%fprintf('Loop run %d times \n', c);

new_idx = coded_img;
end

