im=(imread('image4.jpg'));

im=im2double(im);
delta=[0,0;15.0,-20.0;-20.0,10.0];
phi=[0  5   -4];
scale=4;


im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';

im1 = im; % the first image is not shifted or rotated
%im1 = lowpass(im1,[0.12 0.12]);
im1 = downsample(im1,2*scale)'; % downsample the images by 8
im1 = downsample(im1,2*scale)';

im2 = shift(im,20.0*2*scale,-15.0*2*scale); % shift the images by integer pixels
im2 = imrotate(im2,45,'bicubic','crop'); % rotate the images
%im2 = lowpass(im2,[0.12 0.12]);
im2 = downsample(im2,2*scale)'; % downsample the images by 8
im2 = downsample(im2,2*scale)';

im3 = shift(im,-30.0*2*scale,20.0*2*scale); % shift the images by integer pixels
im3 = imrotate(im3,-30,'bicubic','crop'); % rotate the images
%im2 = lowpass(im2,[0.12 0.12]);
im3 = downsample(im3,2*scale)'; % downsample the images by 8
im3 = downsample(im3,2*scale)';


imwrite(im2uint8(im1),'Cim4_1.tif');
imwrite(im2uint8(im2),'Cim4_2.tif');
imwrite(im2uint8(im2),'Cim4_3.tif');