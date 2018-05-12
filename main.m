clear; 
close all;

% Environment initialization
cb_size = 8; % codebook size
filename = 'images/land_2.jpg';

info = imfinfo(filename);
width = info.Width;
height = info.Height;

img = imread(filename);

%% Codebook and distortion  value initialization initialization
x = reshape(img,[], 3);
%y = 0.3*x(:,1) + 0.59*x(:,2) + 0.11*x(:,3); % NTSC luminance
codebook = uint8(round(mean(x)));
idx = ones(width*height,1);
dist_vec = distortion(x,codebook,idx);

j = 2;
epsilon = 10;

for i = 1:log2(cb_size)
    codebook(j:size(codebook,1)*2,:) = mod(codebook+10,255);
    %[cb, new_idx] = LBG(img, cb, dist, idx, epsilon);
    j = size(codebook,1) + 1; %#ok<FXSET>
end

%% SHOW PALETTE
image(reshape(codebook,8,1,3));
