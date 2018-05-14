clear; 
close all;

% Environment initialization
cb_size = ; % codebook size
filename = 'images/sample_1.jpg';

info = imfinfo(filename);
width = info.Width;
height = info.Height;

img = imread(filename);

%% Codebook and distortion  value initialization initialization
x = im2double(reshape(img,[], 3));
%y = 0.3*x(:,1) + 0.59*x(:,2) + 0.11*x(:,3); % NTSC luminance
codebook(:,1) = mean(x(:,1));
codebook(:,2) = mean(x(:,2));
codebook(:,3) = mean(x(:,3));
idx = ones(width*height,1);
dst = distortion(x,codebook,idx);

j = 2;
epsilon = 10;

for i = 1:log2(cb_size)
    codebook(j:size(codebook,1)*2,:) = mod(codebook+30/255,1);
    [codebook, idx] = LBG(x, codebook, dst, idx, epsilon);
    j = size(codebook,1) + 1;
end

%% SHOW PALETTE
image(reshape(codebook,cb_size,1,3));
