clear; 
close all;

% Environment initialization

rate = 8; %[Bit/s]
filename = 'images/2.tiff';

info = imfinfo(filename);
width = info.Width;
height = info.Height;

img_original = imread(filename);
x = im2double(reshape(img_original,[], 3));

%% CODEBOOK EVALUATION

cb_size = 2^rate; % codebook size

codebook(:,1) = mean(x(:,1));
codebook(:,2) = mean(x(:,2));
codebook(:,3) = mean(x(:,3));
coded_img = ones(size(x,1),1);

j = 2;
epsilon = 0.1;
gain = 0.6;

figure
for i = 1:log2(cb_size)
    codebook(j:size(codebook,1)*2,:) = mod(codebook+80/255,1);
    [codebook, coded_img] = LBG(x, codebook, coded_img, epsilon, gain);
    j = size(codebook,1) + 1;
end

hold on
pcshow(im2double(img_original))

%% IMAGE COMPRESSION

new_image = zeros(size(x,1),3);
for i=1:size(x,1)
    new_image(i,:) = codebook(coded_img(i),:);
end

%% SHOW PALETTE

imwrite(reshape(codebook,cb_size,1,3),'palette.tiff','tiff');
palette = imread('palette.tiff'); 
figure 
image(palette)
title('Palette obtained via LBG')

%% Compression comparison

imwrite(img_original,'img_jpg.jpeg','jpg','Quality',100);
img_jpg = imread('img_jpg.jpeg'); 

imwrite(reshape(new_image,width,height,3),'img_raw.tiff','tiff');
img_lbg = imread('img_raw.tiff'); 

fprintf('Distortion between original and JPG: %.3f \n', immse(img_jpg,img_original))
fprintf('Distortion between original and LBG: %.3f \n', immse(img_lbg,img_original))
%fprintf('Distortion between JPG and LBG: %.3f \n', immse(x_jpg,x_tiff))

fprintf('PSNR between original and JPG: %.3f \n', psnr(img_original,img_jpg,255))
fprintf('PSNR between original and LBG: %.3f \n', psnr(img_original,img_lbg,255))
%fprintf('PSNR between JPG and LBG: %.3f \n', psnr(x_jpg,x_tiff,255))

%% Image plot

img_arr = [img_original img_jpg img_lbg];
figure
montage(img_arr)
