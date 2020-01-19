t1=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];

t2=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];
t3=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];

scale=4;
im=rgb2gray(imread('image.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';

im1 = imtranslate(im,[-t1(3)*2*scale,-t1(2)*2*scale]); % shift the images by integer pixels
im1 = imrotate(im1,t1(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
im1 = downsample(im1,2*scale)'; % downsample the images by 8
im1 = downsample(im1,2*scale)';

im2 = imtranslate(im,[-t2(3)*2*scale,-t2(2)*2*scale]); % shift the images by integer pixels
im2 = imrotate(im2,t2(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
im2 = downsample(im2,2*scale)'; % downsample the images by 8
im2 = downsample(im2,2*scale)';


im3 = imtranslate(im,[-t3(3)*2*scale,-t3(2)*2*scale]); % shift the images by integer pixels
im3 = imrotate(im3,t3(1),'bicubic','crop'); % rotate the images
       %im2 = lowpass(im2,[0.12 0.12]);
im3 = downsample(im3,2*scale)'; % downsample the images by 8
im3 = downsample(im3,2*scale)';

disp(getError(im1,im3,t1,t3))
%disp(getError(im2,im3,t1-t3,t3-t1))
disp(getError(im1,im3,newBase(t2,t1),newBase(t2,t3)))
%disp(t2);
%disp(newBase(t1,t2));


function E=getError(im1b,im2b,im1t,im2t)
im1=imrotate(im1b,-im1t(1),'bicubic','crop');
im2=imrotate(im2b,-im2t(1),'bicubic','crop');

im1=shift(im1,im1t(3),im1t(2));
im2=shift(im2,im2t(3),im2t(2));

%E = sum(sum((im1-im2).^2));

[r, c, ~] = size(im1);
figure,imshow(imabsdiff(im1,im2))
rect=[c/8,r/8,c*3/4,r*3/4];
im1c=(imcrop(im1,rect));
im2c=(imcrop(im2,rect));
[r, c, ~] = size(im1c);
E = sum(imabsdiff(im1c,im2c).^2,'all')/(r*c);

end

function vec=newBase(v1,v2)
    ang=-v1(1);
    x=v2(2)-v1(2);
    y=v2(3)-v1(3);
    vec(2)=(x*cosd(ang)+y*sind(ang));
    vec(3)=(-x*sind(ang)+y*cosd(ang));
    vec(1)=(v2(1)-v1(1));

end