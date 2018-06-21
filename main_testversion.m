clear; 
close all;

% Environment initialization

rate = 8; %[Bit/pixel]
cb_size = 2^rate; % codebook size
filename = 'images/10.tiff';

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
epsilon = [0.001 0.01 0.1];
gain = 1;
delta = 0.2;

for a = 1:3
    
    codebook = mean(x);
    coded_img = ones(size(x,1),1); 
    j = 2;
    
    compressed_img = zeros(size(x,1),3);
    distortion = zeros(log2(cb_size),1);
    psnr_values = zeros(log2(cb_size),1);

    figure
    for i = 1:log2(cb_size)
        codebook(j:size(codebook,1)*2,:) = mod(codebook+delta,1);
        [codebook, coded_img] = LBG(x, codebook, coded_img, epsilon, gain);

        for h=1:size(x,1)
            compressed_img(h,:) = codebook(coded_img(h,1),:);
        end
        imwrite(reshape(compressed_img,width,height,3),sprintf('img_raw_%d.tiff',i),'tiff');
        img_draft = imread(sprintf('img_raw_%d.tiff',i));
        distortion(i) = immse(img_draft,img_original);
        psnr_values(i) =  psnr(img_draft,img_original,255);

        j = size(codebook,1) + 1;
    end
    hold on
    pcshow(im2double(img_original))
    title('RGB pixel cloud')
    legend('LBG Codebook', 'Image pixel cloud')

    save(sprintf('distortion_10%d.mat',a),'distortion');
    save(sprintf('psnr_10%d.mat',a),'psnr_values')

end

%%

imwrite(img_original,'img_jpg.jpeg','jpg','Quality',100);
img_jpg = imread('img_jpg.jpeg'); 
info2 = imfinfo('img_jpg.jpeg');

img_draft = imread('img_raw_8.tiff');
info3 = imfinfo('img_raw_8.tiff');

tiff_rate = (info3.FileSize * 8)/(size(x,1)*8);

%% 

for i = 1:8
    img_one = imread(sprintf('img_raw_%d.tiff',i));
    imwrite(img_one,sprintf('img_png_%d.png',i),'png');
end

%%

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

dist1 = load('distortion_101');
dist2 = load('distortion_102');
dist3 = load('distortion_103');

figure
plot(log2([2 4 8 16 32 64 128 256]),dist1.distortion,'-x','Linewidth',1.5)
grid on
hold on

plot(log2([2 4 8 16 32 64 128 256]),dist2.distortion,'-x','Linewidth',1.5)
plot(log2([2 4 8 16 32 64 128 256]),dist3.distortion,'-x','Linewidth',1.5)
plot(jpg_rate, jpg_distortion,'-x','Linewidth',2)
ylabel('Distortion [mse]')
xlabel('Rate [bit/pixel]')
legend('LBG - \epsilon = 0.001', 'LBG - \epsilon = 0.01', 'LBG - \epsilon = 0.1',  'JPG','Location','northwest')

psnr1 = load('psnr_101');
psnr2 = load('psnr_102');
psnr3 = load('psnr_103');

figure
plot(log2([2 4 8 16 32 64 128 256]),psnr1.psnr_values,'-x','Linewidth',1.5)
grid on
hold on
plot(log2([2 4 8 16 32 64 128 256]),psnr2.psnr_values,'-x','Linewidth',1.5)
plot(log2([2 4 8 16 32 64 128 256]),psnr3.psnr_values,'-x','Linewidth',1.5)
plot(jpg_rate, jpg_psnr,'-x','Linewidth',2)
ylabel('PSNR [dB]')
xlabel('Rate [bit/pixel]')
legend('LBG - \epsilon = 0.001', 'LBG - \epsilon = 0.01', 'LBG - \epsilon = 0.1',  'JPG','Location','northwest')

