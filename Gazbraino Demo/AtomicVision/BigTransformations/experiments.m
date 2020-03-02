im=rgb2gray(imread('image.jpg'));


im=im2double(im);
shift=-15;
shifty=-15;
rot=8;
scale=4;
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
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

for i=1:10
    t2=[normrnd(0,15),normrnd(0,15),normrnd(0,15)];
    t3=[normrnd(0,15),normrnd(0,15),normrnd(0,15)];
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



    tests{i}=[[0,0,0],t2,t3];
    ims{1}=im1;
    ims{2}=im2;
    ims{3}=im3;
        
    [d,p]=keren(ims);

        
        %sE(i,j)=abs(d(2,1)-shift)+abs(d(2,1)-shift);
        %rE(i,j)=abs(p(2)-rot); 
        
        
    im1t=[p(1),d(1,1),d(1,2)];


    im2tA=[p(2),d(2,1),d(2,2)];
    im3tA=[p(3),d(3,1),d(3,2)];

        
        

        
    ims{1}=im2;
    ims{2}=im1;
    ims{3}=im3;

    [d,p]=keren(ims);

    im2tB=[p(1)-p(2),d(1,1)-d(2,1),d(1,2)-d(2,2)];
    im3tB=[p(3)-p(2),d(3,1)-d(2,1),d(3,2)-d(2,2)];


    ims{1}=im3;
    ims{2}=im1;
    ims{3}=im2;

    [d,p]=keren(ims);

    im2tC=[p(3)-p(2),d(3,1)-d(2,1),d(3,2)-d(2,2)];
    im3tC=[p(1)-p(2),d(1,1)-d(2,1),d(1,2)-d(2,2)];


    vals(i,1)=sum([getError(im1,im2,im1t,im2tA),getError(im1,im3,im1t,im3tA),getError(im2,im3,im2tA,im3tA)]);
    vals(i,2)=sum([getError(im1,im2,im1t,im2tB),getError(im1,im3,im1t,im3tB),getError(im2,im3,im2tB,im3tB)]);
    vals(i,3)=sum([getError(im1,im2,im1t,im2tC),getError(im1,im3,im1t,im3tC),getError(im2,im3,im2tC,im3tC)]);
        
        
    im2Ts=[(im2tA);(im2tB);(im2tC)];
    im3Ts=[(im3tA);(im3tB);(im3tC)];

    e=9999;

    % Min Spanning tree
    for im2t=im2Ts.'
        for im3t=im3Ts.'
            currE=sum([getError(im1,im2,im1t,im2t.'),getError(im1,im3,im1t,im3t.'),getError(im2,im3,im2t.',im3t.')]);
            if currE<e
                e=currE;
                opt{1}=im2t.';
                opt{2}=im3t.';
            end
    
        end   
    
    end     
    vals(i,4)=sum([getError(im1,im2,im1t,opt{1}),getError(im1,im3,im1t,opt{2}),getError(im2,im3,opt{1},opt{2})]);
    
    
    e=9999;
    r1a=sort([im2tA(1),im2tB(1),im2tC(1)]);
    r1b=sort([im2tA(2),im2tB(2),im2tC(2)]);
    r1c=sort([im2tA(3),im2tB(3),im2tC(3)]);
    r2a=sort([im3tA(1),im3tB(1),im3tC(1)]);
    r2b=sort([im3tA(2),im3tB(2),im3tC(2)]);
    r2c=sort([im3tA(3),im3tB(3),im3tC(3)]);
    %All possible combinations
    for a1=r1a
        for a2=r1b
            for a3=r1c
                for b1=r2a
                    for b2=r2b
                        for b3=r2c
                            im2t=[a1,a2,a3];
                            im3t=[b1,b2,b3];
                            currE=sum([getError(im1,im2,im1t,im2t),getError(im1,im3,im1t,im3t),getError(im2,im3,im2t,im3t)]);
                            if currE<e
                                e=currE;
                                opt{1}=im2t;
                                opt{2}=im3t;
                            end
    
                        end   
    
                    end   
    
                end  
           

    
            end   
    
        end   
    
    end    
    vals(i,5)=sum([getError(im1,im2,im1t,opt{1}),getError(im1,im3,im1t,opt{2}),getError(im2,im3,opt{1},opt{2})]);
    
    vals(i,6)=sum([getError(im1,im2,im1t,t2),getError(im1,im3,im1t,t3),getError(im2,im3,t2,t3)]);
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
E = sum(sum((im1c-im2c).^2))/(r*c);

end