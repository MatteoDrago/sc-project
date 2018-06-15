clear; 
close all;

% Environment initialization

rate = 8; %[Bit/pixel]
cb_size = 2^rate; % codebook size
filename = 'images/3.tiff';

info = imfinfo(filename);
width = info.Width;
height = info.Height;

img_original = imread(filename);
x = im2double(reshape(img_original,[], 3));

%% CODEBOOK EVALUATION

codebook = mean(x);
coded_img = ones(size(x,1),1);

j = 2;

% Parameters set up
epsilon = 0.001;
gain = 0.9;
delta = 0.2;

figure
for i = 1:log2(cb_size)
    codebook(j:size(codebook,1)*2,:) = mod(codebook+delta,1);
    [codebook, coded_img] = LBG(x, codebook, coded_img, epsilon, gain);
    j = size(codebook,1) + 1;
end

hold on
pcshow(im2double(img_original))

%% IMAGE COMPRESSION

compressed_img = zeros(size(x,1),3);
for i=1:size(x,1)
    compressed_img(i,:) = codebook(coded_img(i),:);
end

%% SHOW PALETTE

% [~ ,  idx] = min(codebook,[], 1);
% cb_workcopy = codebook;
% ordered_cb = zeros(cb_size,3);
% idx = idx(3);
% next = cb_workcopy(idx,:);
% 
% for i=1:cb_size
%     
%     ordered_cb(i,:) = next;
%     cb_workcopy(idx,:) = [];
%     
%     if i ~= cb_size
%         distance_vect = sum((repmat(next,size(cb_workcopy,1),1)-cb_workcopy(:,:)).^2,2).^0.5;
%         [~ ,  idx] = min(distance_vect);
%         next = cb_workcopy(idx,:);
%     end
%     
% end
% imwrite(reshape(ordered_cb,cb_size,1,3),'palette.tiff','tiff');
% %imwrite(reshape(codebook,cb_size,1,3),'palette.tiff','tiff');
% palette = imread('palette.tiff'); 
% figure 
% image(palette)
% title('Palette obtained via LBG')

%% Compression comparison

imwrite(img_original,'img_jpg.jpeg','jpg','Quality',100);
img_jpg = imread('img_jpg.jpeg'); 
info2 = imfinfo('img_jpg.jpeg');

imwrite(reshape(compressed_img,width,height,3),'img_raw.tiff','tiff');
img_lbg = imread('img_raw.tiff');
info3 = imfinfo('img_raw.tiff');

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
