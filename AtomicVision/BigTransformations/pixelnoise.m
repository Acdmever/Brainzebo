im=rgb2gray(imread('image.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
%im=resample(im,2,1)';
errsBase{1}=getBaseVals(im);



im=rgb2gray(imread('image2.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
%im=resample(im,2,1)';
errsBase{2}=getBaseVals(im);


im=rgb2gray(imread('image3.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{3}=getBaseVals(im);


im=(imread('image4.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{4}=getBaseVals(im);


im=rgb2gray(imread('cameraman.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{5}=getBaseVals(im);


im=(imread('120.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{6}=getBaseVals(im);


im=rgb2gray(imread('text.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{7}=getBaseVals(im);


im=rgb2gray(imread('alpaca.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{8}=getBaseVals(im);

function pixE=getBaseVals(im)
    scale=4;
    i=1;
    im1b = im; % the first image is not shifted or rotated
    %im1 = lowpass(im1,[0.12 0.12]);
    im1b = downsample(im1b,2*scale)'; % downsample the images by 8
    im1b = downsample(im1b,2*scale)';
    k=1;
    for ns=[0.0,0.1,0.5,1.0]
        im1=imnoise(im1b,'gaussian',0.0,ns);
        i=1;
        for rot=-30.0:2.0:30.0
            j=1;

            for shift=-30.0:2.0:30.0
                im2 = imtranslate(im,[-shift*2*scale,-shift*2*scale]); % shift the images by integer pixels
                im2 = imrotate(im2,rot,'bicubic','crop'); % rotate the images
                %im2 = lowpass(im2,[0.12 0.12]);
                im2 = downsample(im2,2*scale)'; % downsample the images by 8
                im2 = downsample(im2,2*scale)';
                im2=imnoise(im2,'gaussian',0.0,ns);




                %sE(i,j)=abs(d(2,1)-shift)+abs(d(2,1)-shift);
                %rE(i,j)=abs(p(2)-rot);

                err(i,j)=getError(im1,im2,[0,0,0],[0,0,0]);
                j=j+1;
            end
            i=i+1;
        end
        pixE{k}=err;
        k=k+1;
    end
end






function E=getError(im1b,im2b,im1t,im2t)

im1=imrotate(im1b,-im1t(1),'bicubic','crop');
im2=imrotate(im2b,-im2t(1),'bicubic','crop');

im1=shift(im1,im1t(3),im1t(2));
im2=shift(im2,im2t(3),im2t(2));

%E = sum(sum((im1-im2).^2));

[r, c, ~] = size(im1);

rect=[c/8,r/8,c*3/4,r*3/4];
im1c=(imcrop(im1,rect));
im2c=(imcrop(im2,rect));
[r, c, ~] = size(im1c);
E = sum(imabsdiff(im1c,im2c).^2,'all')/(r*c);

end