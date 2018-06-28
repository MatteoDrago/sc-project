clear; 
close all;

%% Environment initialization

rate = 8; %[Bit/pixel]
cb_size = 2^rate; % codebook size
filename = '8.tiff';

if ismac
    filename = ['images/',filename];
else
    filename = ['images\',filename];
end

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
gain = 1;
delta = 0.2;

compressed_img = zeros(size(x,1),3);
distortion = zeros(log2(cb_size),1);
psnr_values = zeros(log2(cb_size),1);

l = figure; 
axis tight manual
for i = 1:log2(cb_size)
    codebook(j:size(codebook,1)*2,:) = mod(codebook+delta,1);
    [codebook, coded_img] = LBG(x, codebook, coded_img, epsilon, gain);
    
    frame = getframe(l); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 

    % Write to the GIF File 
    if i == 1 
        imwrite(imind,cm,'test.gif','gif', 'Loopcount',inf); 
    else 
        imwrite(imind,cm,'test.gif','gif','WriteMode','append'); 
    end 
        
    
    for h=1:size(x,1)
        compressed_img(h,:) = codebook(coded_img(h,1),:);
    end
    
    imwrite(reshape(compressed_img,width,height,3),sprintf('img_raw_%d.tiff',i),'tiff');
    
    img_draft = imread(sprintf('img_raw_%d.tiff',i));
    
    [imind,cm] = rgb2ind(img_draft,256); 
    if i == 1 
          imwrite(imind,cm,'test_2.gif','gif', 'Loopcount',inf); 
    else 
          imwrite(imind,cm,'test_2.gif','gif','WriteMode','append'); 
    end
    
    distortion(i) = immse(img_draft,img_original);
    psnr_values(i) =  psnr(img_draft,img_original,255);
    
    j = size(codebook,1) + 1;
end

hold on
pcshow(im2double(img_original))
title('RGB pixel cloud')
% frame = getframe(l); 
% im = frame2im(frame); 
% [imind,cm] = rgb2ind(im,256);
% imwrite(imind,cm,'test.gif','gif','WriteMode','append'); 
legend('LBG Codebook', 'Image pixel cloud')

%% IMAGE COMPRESSION

compressed_img = zeros(size(x,1),3);
for i=1:size(x,1)
    compressed_img(i,:) = codebook(coded_img(i),:);
end

%% SHOW PALETTE - CODEBOOK SORTING

[~ , idx] = min(codebook,[], 1);
cb_workcopy = codebook;
ordered_cb = zeros(cb_size,3);
idx = idx(3);
next = cb_workcopy(idx,:);

for i=1:cb_size
    
    ordered_cb(i,:) = next;
    cb_workcopy(idx,:) = [];
    
    if i ~= cb_size
        distance_vect = sum((repmat(next,size(cb_workcopy,1),1)-cb_workcopy(:,:)).^2,2).^0.5;
        [~ ,  idx] = min(distance_vect);
        next = cb_workcopy(idx,:);
    end
    
end

palette_img = ones(1,256).*reshape(ordered_cb,cb_size,1,3);
imwrite(palette_img,'palette.png','png');
palette = imread('palette.png');

figure 
imshow(palette)
title('Palette obtained via LBG')

%% Compression Comparison

jpg_rate = zeros(10,1);
jpg_distortion = zeros(10,1);
jpg_psnr = zeros(10,1);

for i = 1:10
    imwrite(img_original,'X.jpeg','jpg','Quality',i*10);
    xr = imread('X.jpeg');
    infoxr = imfinfo('X.jpeg');
    Size = infoxr.FileSize*8;

    jpg_rate(i) = Size/size(x,1);
    jpg_distortion(i) = immse(xr,img_original);
    jpg_psnr(i) = psnr(xr,img_original,255);
end

figure
plot(log2([2 4 8 16 32 64 128 256]),distortion,'-x','Linewidth',1.5)
grid on
hold on
plot(jpg_rate, jpg_distortion,'-x','Linewidth',2)
ylabel('Distortion [mse]')
xlabel('Rate [bit/pixel]')
legend('LBG', 'JPG','Location','northwest')

figure
plot(log2([2 4 8 16 32 64 128 256]),psnr_values,'-x','Linewidth',1.5)
grid on
hold on
plot(jpg_rate, jpg_psnr,'-x','Linewidth',2)
ylabel('PSNR [dB]')
xlabel('Rate [bit/pixel]')
legend('LBG', 'JPG','Location','northwest')

%% Image plot

imwrite(img_original,'img_jpg.jpeg','jpg','Quality',100);
img_jpg = imread('img_jpg.jpeg');

imwrite(reshape(compressed_img,width,height,3),'img_raw.tiff','tiff');
img_lbg = imread('img_raw.tiff');

img_arr = [img_original img_jpg img_lbg];
figure
imshow(img_original)
title('Original image')
figure
imshow(img_jpg)
title('JPG Image')
figure
imshow(img_lbg)
title('Image quantized using LBG')
