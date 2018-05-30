clear; 
close all;

% Environment initialization
cb_size = 256; % codebook size
filename = 'images/1.tiff';

info = imfinfo(filename);
width = info.Width;
height = info.Height;

img = imread(filename);
x = im2double(reshape(img,[], 3));

rate = 8; %[Bit/s]

imwrite(img,'X.jpeg','jpg');
x_jpg = imread('X.jpeg'); 

%% CODEBOOK EVALUATION

[codebook, coded_img] = computeCodebook(x, 2^rate);

%% SHOW PALETTE
%[~,idx] = sort(codebook(:,3)); % sort just the first column
%sorted_cb = codebook(idx,:);   % sort the whole matrix using the sort indices

imwrite(reshape(codebook,cb_size,1,3),'palette.tiff','tiff');
palette = imread('palette.tiff'); 

%% IMAGE COMPRESSION

new_image = zeros(size(x,1),3);
for i=1:size(x,1)
    new_image(i,:) = codebook(coded_img(i),:);
end

imwrite(reshape(new_image,width,height,3),'X.tiff','tiff');
x_tiff = imread('X.tiff'); 
%image(reshape(new_image,width,height,3));

%% Image plot

% figure 
% subplot(2,2,1)
% imshow(img)
% title('Original Image (TIF format)')
% subplot(2,2,2)
% imshow(x_jpg)
% title('Compressed Image (JPG format)')
% subplot(2,2,3)
% imshow(x_tiff)
% title('Compressed Image (LBG Algorithm)')
% subplot(2,2,4)

img_arr = [img x_jpg x_tiff palette];
figure
montage(img_arr)
figure 
image(palette)
title('Palette obtained via LBG')

fprintf('Distortion between original and JPG: %.3f \n', immse(x_jpg,img))
fprintf('Distortion between original and LBG: %.3f \n', immse(x_tiff,img))
fprintf('Distortion between JPG and LBG: %.3f \n', immse(x_jpg,x_tiff))

fprintf('PSNR between original and JPG: %.3f \n', psnr(x_jpg,img,255))
fprintf('PSNR between original and LBG: %.3f \n', psnr(x_tiff,img,255))
fprintf('PSNR between JPG and LBG: %.3f \n', psnr(x_jpg,x_tiff,255))