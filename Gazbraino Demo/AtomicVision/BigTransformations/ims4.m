%im=rgb2gray(imread('image.jpg'));
%im=im2double(im);
%im=resample(im,2,1)'; % upsample the image by 2
%im=resample(im,2,1)';
%im=resample(im,2,1)';
%errsN{1}=getNoiseVals(im);
%errsT{1}=getTrVals(im);
%disp('Next');

im=rgb2gray(imread('image2.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
%im=resample(im,2,1)';
errsN{1}=getNoiseVals(im);
errsT{1}=getTrVals(im);
disp('Next');
im=rgb2gray(imread('image3.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsN{2}=getNoiseVals(im);
errsT{2}=getTrVals(im);
disp('Next');
im=(imread('image4.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsN{3}=getNoiseVals(im);
errsT{3}=getTrVals(im);
disp('Next');
im=rgb2gray(imread('cameraman.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsN{4}=getNoiseVals(im);
errsT{4}=getTrVals(im);
disp('Next');
im=(imread('120.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsN{5}=getNoiseVals(im);
errsT{5}=getTrVals(im);
disp('Next');
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
errsN{6}=getNoiseVals(im);
errsT{6}=getTrVals(im);
disp('Next');
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
errsN{7}=getNoiseVals(im);
errsT{7}=getTrVals(im);


function pixE=getNoiseVals(im)
    %im=im2double(im);
    %shiftx=-15;
    %shifty=-15;
    %rot=8;
    scale=4;
    %im=resample(im,2,1)'; % upsample the image by 2
    %im=resample(im,2,1)';
    %im=resample(im,2,1)'; % upsample the image by 2
    %im=resample(im,2,1)';
    %im=resample(im,2,1)'; % upsample the image by 2
    %im=resample(im,2,1)';
    %im=resample(im,2,1)'; % upsample the image by 2
%im=resample(im,2,1)';

    im1b = im; % the first image is not shifted or rotated
    %im1 = lowpass(im1,[0.12 0.12]);
    im1b = downsample(im1b,2*scale)'; % downsample the images by 8
    im1b = downsample(im1b,2*scale)';
    %[r,c,ch]=size(im1);
    %pixels=r*c;

    i=1;

        
    for ns=0.0:0.05:1.0
        j=1;
        for test=0:50
            t2=[max(-30,min(normrnd(0,15),30)),max(-30,min(normrnd(0,15),30)),max(-30,min(normrnd(0,15),30))];
            im2 = imtranslate(im,[-t2(3)*2*scale,-t2(2)*2*scale]); % shift the images by integer pixels
            im2 = imrotate(im2,t2(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
            im2 = downsample(im2,2*scale)'; % downsample the images by 8
            im2 = downsample(im2,2*scale)';
        
            t3=[max(-30,min(normrnd(0,15),30)),max(-30,min(normrnd(0,15),30)),max(-30,min(normrnd(0,15),30))];
            im3 = imtranslate(im,[-t3(3)*2*scale,-t3(2)*2*scale]); % shift the images by integer pixels
            im3 = imrotate(im3,t3(1),'bicubic','crop'); % rotate the images
            im3 = downsample(im3,2*scale)'; % downsample the images by 8
            im3 = downsample(im3,2*scale)';
            
            t4=[max(-30,min(normrnd(0,15),30)),max(-30,min(normrnd(0,15),30)),max(-30,min(normrnd(0,15),30))];
            im4 = imtranslate(im,[-t4(3)*2*scale,-t4(2)*2*scale]); % shift the images by integer pixels
            im4 = imrotate(im4,t4(1),'bicubic','crop'); % rotate the images
            im4 = downsample(im4,2*scale)'; % downsample the images by 8
            im4 = downsample(im4,2*scale)';
            
            im1=imnoise(im1b,'gaussian',0.0,ns);
            im2=imnoise(im2,'gaussian',0.0,ns);
            im3=imnoise(im3,'gaussian',0.0,ns);
            im4=imnoise(im4,'gaussian',0.0,ns);
    
            ims{1}=im1;
            ims{2}=im2;
            ims{3}=im3;
            ims{4}=im4;
            
            [d,p]=keren(ims);
            im1t=[0,0,0];


            im2tA=[p(2),d(2,1),d(2,2)];
            im3tA=[p(3),d(3,1),d(3,2)];
            im4tA=[p(4),d(4,1),d(4,2)];

        
        

        
            ims{1}=im2;
            ims{2}=im1;
            ims{3}=im3;
            ims{4}=im4;

            [d,p]=keren(ims);

            im2tB=[p(1)-p(2),d(1,1)-d(2,1),d(1,2)-d(2,2)];
            im3tB=[p(3)-p(2),d(3,1)-d(2,1),d(3,2)-d(2,2)];
            im4tB=[p(4)-p(2),d(4,1)-d(2,1),d(4,2)-d(2,2)];


            ims{1}=im3;
            ims{2}=im1;
            ims{3}=im2;
            ims{4}=im4;

            [d,p]=keren(ims);

            im2tC=[p(3)-p(2),d(3,1)-d(2,1),d(3,2)-d(2,2)];
            im3tC=[p(1)-p(2),d(1,1)-d(2,1),d(1,2)-d(2,2)];
            im4tC=[p(4)-p(2),d(4,1)-d(2,1),d(4,2)-d(2,2)];
        
            
            
            ims{1}=im4;
            ims{2}=im1;
            ims{3}=im2;
            ims{4}=im3;

            [d,p]=keren(ims);

            im2tD=[p(3)-p(2),d(3,1)-d(2,1),d(3,2)-d(2,2)];
            im3tD=[p(4)-p(2),d(4,1)-d(2,1),d(4,2)-d(2,2)];
            im4tD=[p(1)-p(2),d(1,1)-d(2,1),d(1,2)-d(2,2)];
        
            im2Ts=[(im2tA);(im2tB);(im2tC);(im2tD)];
            im3Ts=[(im3tA);(im3tB);(im3tC);(im3tD)];
            im4Ts=[(im4tA);(im4tB);(im4tC);(im4tD)];

            e=9999;

            % Min Spanning tree
            for im2t=im2Ts.'
                for im3t=im3Ts.'
                    for im4t=im4Ts.'
                    %disp(im2t.');
                        currE=sum([getError(im1,im2,im1t,im2t.'),getError(im1,im3,im1t,im3t.'),getError(im2,im3,im2t.',im3t.'),getError(im1,im4,im1t,im4t.'),getError(im2,im4,im2t.',im4t.'),getError(im3,im4,im3t.',im4t.')]);
                        if currE<e
                            e=currE;
                            opt{1}=im2t.';
                            opt{2}=im3t.';
                            opt{3}=im4t.';
                        end
                    end
                end   
    
            end     
        %vals(i,4)=sum([getError(im1,im2,im1t,opt{1}),getError(im1,im3,im1t,opt{2}),getError(im2,im3,opt{1},opt{2})]);
        
        %sE(i,j)=abs(d(2,1)-shift)+abs(d(2,1)-shift);
        %rE(i,j)=abs(p(2)-rot);
        
            e(j)=getError(im1,im2,[0,0,0],opt{1});
            sE(j)=abs(opt{1}(1,2)-t2(2))+abs(opt{1}(1,3)-t2(3));
            rE(j)=abs(opt{1}(1,1)-t2(1));
            j=j+1;
        end
        pixE(1,i)=mean(e);
        pixE(2,i)=mean(rE);
        pixE(3,i)=mean(sE);
        i=i+1;
    end
end


function pixE=getTrVals(im)
    %im=im2double(im);
    %shiftx=-15;
    %shifty=-15;
    %rot=8;
    scale=4;
    %im=resample(im,2,1)'; % upsample the image by 2
    %im=resample(im,2,1)';
    %im=resample(im,2,1)'; % upsample the image by 2
    %im=resample(im,2,1)';
    %im=resample(im,2,1)'; % upsample the image by 2
    %im=resample(im,2,1)';
    %im=resample(im,2,1)'; % upsample the image by 2
%im=resample(im,2,1)';

    im1 = im; % the first image is not shifted or rotated
    %im1 = lowpass(im1,[0.12 0.12]);
    im1 = downsample(im1,2*scale)'; % downsample the images by 8
    im1 = downsample(im1,2*scale)';
    %[r,c,ch]=size(im1);
    %pixels=r*c;

    i=1;

    %t3=[normrnd(0,15),normrnd(0,15),normrnd(0,15)];
    %im3 = imtranslate(im,[-t3(3)*2*scale,-t3(2)*2*scale]); % shift the images by integer pixels
    %im3 = imrotate(im3,t3(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
    %im3 = downsample(im3,2*scale)'; % downsample the images by 8
    %im3 = downsample(im3,2*scale)';
        
    for rot=-30.0:2.0:30.0
        j=1;
        for shift=-30.0:2.0:30.0
            im2 = imtranslate(im,[-shift*2*scale,-shift*2*scale]); % shift the images by integer pixels
            im2 = imrotate(im2,rot,'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
            im2 = downsample(im2,2*scale)'; % downsample the images by 8
            im2 = downsample(im2,2*scale)';
        
            t3=[max(-30,min(normrnd(0,15),30)),max(-30,min(normrnd(0,15),30)),max(-30,min(normrnd(0,15),30))];
            im3 = imtranslate(im,[-t3(3)*2*scale,-t3(2)*2*scale]); % shift the images by integer pixels
            im3 = imrotate(im3,t3(1),'bicubic','crop'); % rotate the images
            im3 = downsample(im3,2*scale)'; % downsample the images by 8
            im3 = downsample(im3,2*scale)';
    
    
            t4=[max(-30,min(normrnd(0,15),30)),max(-30,min(normrnd(0,15),30)),max(-30,min(normrnd(0,15),30))];
            im4 = imtranslate(im,[-t4(3)*2*scale,-t4(2)*2*scale]); % shift the images by integer pixels
            im4 = imrotate(im4,t4(1),'bicubic','crop'); % rotate the images
            im4 = downsample(im4,2*scale)'; % downsample the images by 8
            im4 = downsample(im4,2*scale)';
            
            
    
            ims{1}=im1;
            ims{2}=im2;
            ims{3}=im3;
            ims{4}=im4;
            
            [d,p]=keren(ims);
            im1t=[0,0,0];


            im2tA=[p(2),d(2,1),d(2,2)];
            im3tA=[p(3),d(3,1),d(3,2)];
            im4tA=[p(4),d(4,1),d(4,2)];

        
        

        
            ims{1}=im2;
            ims{2}=im1;
            ims{3}=im3;
            ims{4}=im4;

            [d,p]=keren(ims);

            im2tB=[p(1)-p(2),d(1,1)-d(2,1),d(1,2)-d(2,2)];
            im3tB=[p(3)-p(2),d(3,1)-d(2,1),d(3,2)-d(2,2)];
            im4tB=[p(4)-p(2),d(4,1)-d(2,1),d(4,2)-d(2,2)];


            ims{1}=im3;
            ims{2}=im1;
            ims{3}=im2;
            ims{4}=im4;

            [d,p]=keren(ims);

            im2tC=[p(3)-p(2),d(3,1)-d(2,1),d(3,2)-d(2,2)];
            im3tC=[p(1)-p(2),d(1,1)-d(2,1),d(1,2)-d(2,2)];
            im4tC=[p(4)-p(2),d(4,1)-d(2,1),d(4,2)-d(2,2)];
        
            
            
            ims{1}=im4;
            ims{2}=im1;
            ims{3}=im2;
            ims{4}=im3;

            [d,p]=keren(ims);

            im2tD=[p(3)-p(2),d(3,1)-d(2,1),d(3,2)-d(2,2)];
            im3tD=[p(4)-p(2),d(4,1)-d(2,1),d(4,2)-d(2,2)];
            im4tD=[p(1)-p(2),d(1,1)-d(2,1),d(1,2)-d(2,2)];
        
            im2Ts=[(im2tA);(im2tB);(im2tC);(im2tD)];
            im3Ts=[(im3tA);(im3tB);(im3tC);(im3tD)];
            im4Ts=[(im4tA);(im4tB);(im4tC);(im4tD)];

            e=9999;

            % Min Spanning tree
            for im2t=im2Ts.'
                for im3t=im3Ts.'
                    for im4t=im4Ts.'
                    %disp(im2t.');
                        currE=sum([getError(im1,im2,im1t,im2t.'),getError(im1,im3,im1t,im3t.'),getError(im2,im3,im2t.',im3t.'),getError(im1,im4,im1t,im4t.'),getError(im2,im4,im2t.',im4t.'),getError(im3,im4,im3t.',im4t.')]);
                        if currE<e
                            e=currE;
                            opt{1}=im2t.';
                            opt{2}=im3t.';
                            opt{3}=im4t.';
                        end
                    end
                end   
    
            end     
        %vals(i,4)=sum([getError(im1,im2,im1t,opt{1}),getError(im1,im3,im1t,opt{2}),getError(im2,im3,opt{1},opt{2})]);
        
        %sE(i,j)=abs(d(2,1)-shift)+abs(d(2,1)-shift);
        %rE(i,j)=abs(p(2)-rot);
        
            pixE(i,j)=getError(im1,im2,[0,0,0],opt{1});
            j=j+1;
        end
        i=i+1;
    end
end


function E=getError(im1b,im2b,im1t,im2t)
if im2t(1)==0
    disp(im2t)
end
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
E = sum(sum((im1c-im2c).^2))/(r*c);

end