im=rgb2gray(imread("cameraman.png"));
scale=4;
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im = downsample(im,2*scale)'; % downsample the images by 8
im = downsample(im,2*scale)';
im1=imnoise(im,'gaussian',0.0,0.1);
im2=imnoise(im,'gaussian',0.0,0.5);
im3=imnoise(im,'gaussian',0.0,1.0);
imwrite(im1,"camera1.jpg");
imwrite(im2,"camera2.jpg");
imwrite(im3,"camera3.jpg");