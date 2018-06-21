% Source Coding
%
%
% RateDistortionCurveJPEG.m:  Compute the JPEG rate distortion curve 

clear all; close all;

filename = 'images/1.tiff';

info = imfinfo(filename);
x = imread(filename);  

%[Nx Ny] = size(x);

Nx = info.Width;
Ny = info.Height;

figure(1)
imshow(x); 
%colormap('gray'); axis('square')

for Q = 0:1:100
imwrite(x,'X.jpeg','jpg','Quality',Q);
xr = imread('X.jpeg');
infoxr = imfinfo('X.jpeg');
Size = infoxr.FileSize*8;

Rate(Q+1) = Size/(Nx*Ny);
Distortion(Q+1) = immse(xr,x);
PSNR(Q+1) = psnr(xr,x,255);
end

figure(2);
plot(Rate,Distortion);
title('JPEG rate distortion curve');
xlabel('rate  [bpp]');
ylabel('MSE');

figure(3);
plot(Rate,PSNR);
title('JPEG rate distortion curve');
xlabel('rate  [bpp]');
ylabel('PSNR  [dB]');