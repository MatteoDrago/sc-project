function [codebook, coded_img] = computeCodebook(img, cb_size)
%COMPUTECODEBOOK Summary of this function goes here
%   Detailed explanation goes here

% Codebook initialization: we use as starting point the barycenter of the
% RGB image
codebook(:,1) = mean(img(:,1));
codebook(:,2) = mean(img(:,2));
codebook(:,3) = mean(img(:,3));
coded_img = ones(size(img,1),1);

j = 2;
epsilon = 10;
gain = 0.3;

for i = 1:log2(cb_size)
    codebook(j:size(codebook,1)*2,:) = mod(codebook+50/255,1);
    [codebook, coded_img] = LBG(img, codebook, coded_img, epsilon, gain);
    j = size(codebook,1) + 1;
end

end

