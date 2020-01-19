for i=1:30
    allt1{i}=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];
    allt2{i}=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];
    allt3{i}=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];
end

    
im=rgb2gray(imread('image.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
%im=resample(im,2,1)';
errsBase{1}=getBaseVals(im,allt1,allt2,allt3);
errsTest{1}=getTestVals(im,allt1,allt2,allt3);


im=rgb2gray(imread('image2.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
%im=resample(im,2,1)';
errsBase{2}=getBaseVals(im,allt1,allt2,allt3);
errsTest{2}=getTestVals(im,allt1,allt2,allt3);


im=rgb2gray(imread('image3.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{3}=getBaseVals(im,allt1,allt2,allt3);
errsTest{3}=getTestVals(im,allt1,allt2,allt3);


im=(imread('image4.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{4}=getBaseVals(im,allt1,allt2,allt3);
errsTest{4}=getTestVals(im,allt1,allt2,allt3);


im=rgb2gray(imread('cameraman.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{5}=getBaseVals(im,allt1,allt2,allt3);
errsTest{5}=getTestVals(im,allt1,allt2,allt3);


im=(imread('120.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{6}=getBaseVals(im,allt1,allt2,allt3);
errsTest{6}=getTestVals(im,allt1,allt2,allt3);


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
errsBase{7}=getBaseVals(im,allt1,allt2,allt3);
errsTest{7}=getTestVals(im,allt1,allt2,allt3);


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
errsBase{8}=getBaseVals(im,allt1,allt2,allt3);
errsTest{8}=getTestVals(im,allt1,allt2,allt3);


function pixE=getBaseVals(im,allt1,allt2,allt3)

    scale=4;


    im1b = im; % the first image is not shifted or rotated
    %im1 = lowpass(im1,[0.12 0.12]);
    im1b = downsample(im1b,2*scale)'; % downsample the images by 8
    im1b = downsample(im1b,2*scale)';

    i=1;

    
    for test=1:30
        t1=allt1{test};
        im1 = imtranslate(im,[-t1(3)*2*scale,-t1(2)*2*scale]); % shift the images by integer pixels
        im1 = imrotate(im1,t1(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
        im1 = downsample(im1,2*scale)'; % downsample the images by 8
        im1 = downsample(im1,2*scale)';
        im1s{test}=im1;
        
        
        t2=allt2{test};
        im2 = imtranslate(im,[-t2(3)*2*scale,-t2(2)*2*scale]); % shift the images by integer pixels
        im2 = imrotate(im2,t2(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
        im2 = downsample(im2,2*scale)'; % downsample the images by 8
        im2 = downsample(im2,2*scale)';
        im2s{test}=im2;
            
        t3=allt3{test};
        im3 = imtranslate(im,[-t3(3)*2*scale,-t3(2)*2*scale]); % shift the images by integer pixels
        im3 = imrotate(im3,t3(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
        im3 = downsample(im3,2*scale)'; % downsample the images by 8
        im3 = downsample(im3,2*scale)';
        im3s{test}=im3;
    end
        
    for ns=0.0:0.1:1.0
        j=1;
        for test=1:30
            
            
            t1=allt1{test};   
            t2=newBase(t1,allt2{test});
            t3=newBase(t1,allt3{test});
            ims{1}=imnoise(im1s{test},'gaussian',0.0,ns);
            ims{2}=imnoise(im2s{test},'gaussian',0.0,ns);
            ims{3}=imnoise(im3s{test},'gaussian',0.0,ns);

            [d,p]=keren(ims);

    
            e(j,i)=sum([getError(ims{1},ims{2},[0,0,0],[p(2),d(2,1),d(2,2)]),getError(ims{1},ims{3},[0,0,0],[p(3),d(3,1),d(2,2)]),getError(ims{2},ims{3},[p(2),d(2,1),d(2,2)],[p(3),d(3,1),d(3,2)])]);
        
            sE(j,i)=abs(d(2,1)-t2(2))+abs(d(2,2)-t2(3))+abs(d(3,1)-t3(2))+abs(d(3,2)-t3(3));
            rE(j,i)=abs(p(2)-t2(1))+abs(p(3)-t3(1));
        
            j=j+1;
        end
        
        
        i=i+1;
    end
    pixE{1}=(e);
    pixE{2}=(rE);
    pixE{3}=(sE);
end

function pixE=getTestVals(im,allt1,allt2,allt3)

    scale=4;


    im1b = im; % the first image is not shifted or rotated
    %im1 = lowpass(im1,[0.12 0.12]);
    im1b = downsample(im1b,2*scale)'; % downsample the images by 8
    im1b = downsample(im1b,2*scale)';

    i=1;

    for test=1:30
        
        t1=allt1{test};
        im1 = imtranslate(im,[-t1(3)*2*scale,-t1(2)*2*scale]); % shift the images by integer pixels
        im1 = imrotate(im1,t1(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
        im1 = downsample(im1,2*scale)'; % downsample the images by 8
        im1 = downsample(im1,2*scale)';
        im1s{test}=im1;
        
        
        t2=allt2{test};
        im2 = imtranslate(im,[-t2(3)*2*scale,-t2(2)*2*scale]); % shift the images by integer pixels
        im2 = imrotate(im2,t2(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
        im2 = downsample(im2,2*scale)'; % downsample the images by 8
        im2 = downsample(im2,2*scale)';
        im2s{test}=im2;
            
        t3=allt3{test};
        im3 = imtranslate(im,[-t3(3)*2*scale,-t3(2)*2*scale]); % shift the images by integer pixels
        im3 = imrotate(im3,t3(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
        im3 = downsample(im3,2*scale)'; % downsample the images by 8
        im3 = downsample(im3,2*scale)';
        im3s{test}=im3;
    end
    
    for ns=0.0:0.1:1.0
        j=1;
        for test=1:30
            t1=allt1{test};   
            t2=newBase(t1,allt2{test});
            t3=newBase(t1,allt3{test});


            im1=imnoise(im1s{test},'gaussian',0.0,ns);
            im2=imnoise(im2s{test},'gaussian',0.0,ns);
            im3=imnoise(im3s{test},'gaussian',0.0,ns);


            ims{1}=im1;
            ims{2}=im2;
            ims{3}=im3;


            [d,p]=keren(ims);
            im1t=[0,0,0];


            im2tA=[p(2),d(2,1),d(2,2)];
            im3tA=[p(3),d(3,1),d(3,2)];


            ims{1}=im2;
            ims{2}=im1;
            ims{3}=im3;


            [d,p]=keren(ims);

            im2tB=newBase([p(2),d(2,1),d(2,2)],[p(1),d(1,1),d(1,2)]);
            im3tB=newBase([p(2),d(2,1),d(2,2)],[p(3),d(3,1),d(3,2)]);


            ims{1}=im3;
            ims{2}=im1;
            ims{3}=im2;


            [d,p]=keren(ims);

            im2tC=newBase([p(2),d(2,1),d(2,2)],[p(3),d(3,1),d(3,2)]);
            im3tC=newBase([p(2),d(2,1),d(2,2)],[p(1),d(1,1),d(1,2)]);





           
            im2Ts=[(im2tA);(im2tB);(im2tC)];
            im3Ts=[(im3tA);(im3tB);(im3tC)];
            err=9999;


  

            % Min Spanning tree
            for im2t=im2Ts.'
                for im3t=im3Ts.'
                    
                    currE=sum([getError(im1,im2,im1t,im2t.'),getError(im1,im3,im1t,im3t.'),getError(im2,im3,im2t.',im3t.')]);
                    if currE<err
                        err=currE;
                        opt{1}=im2t.';
                        opt{2}=im3t.';
                    end
    
                end   
    
            end
            e(j,i)=err;
            
            sE(j,i)=abs(opt{1}(2)-t2(2))+abs(opt{1}(3)-t2(3))+abs(opt{2}(2)-t3(2))+abs(opt{2}(3)-t3(3));
            rE(j,i)=abs(opt{1}(1)-t2(1))+abs(opt{2}(1)-t3(1));
        
            j=j+1;
        end
        
        
        i=i+1;
    end
    pixE{1}=(e);
    pixE{2}=(rE);
    pixE{3}=(sE);
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

function vec=newBase(v1,v2)
    ang=-v1(1);
    x=v2(2)-v1(2);
    y=v2(3)-v1(3);
    vec(2)=(x*cosd(ang)+y*sind(ang));
    vec(3)=(-x*sind(ang)+y*cosd(ang));
    vec(1)=(v2(1)-v1(1));

end
