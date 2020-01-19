%im=rgb2gray(imread('image.jpg'));
%im=im2double(im);
%im=resample(im,2,1)'; % upsample the image by 2
%im=resample(im,2,1)';
%im=resample(im,2,1)';
%errs{1}=getVals(im);


%im=rgb2gray(imread('image2.jpg'));
%im=im2double(im);
%im=resample(im,2,1)'; % upsample the image by 2
%im=resample(im,2,1)';
%im=resample(im,2,1)';
%errs{2}=getVals(im);


im=rgb2gray(imread('image3.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errs{3}=getVals(im);


im=(imread('image4.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errs{4}=getVals(im);


im=rgb2gray(imread('cameraman.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errs{5}=getVals(im);


im=(imread('120.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errs{6}=getVals(im);


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
errs{7}=getVals(im);


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
errs{8}=getVals(im);


function pixE=getVals(im)
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

    t3=[normrnd(0,15),normrnd(0,15),normrnd(0,15)];
    im3 = imtranslate(im,[-t3(3)*2*scale,-t3(2)*2*scale]); % shift the images by integer pixels
    im3 = imrotate(im3,t3(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
    im3 = downsample(im3,2*scale)'; % downsample the images by 8
    im3 = downsample(im3,2*scale)';
        
    for rot=-30.0:2.0:30.0
        j=1;
        for shift=-30.0:2.0:30.0
            im2 = imtranslate(im,[-shift*2*scale,-shift*2*scale]); % shift the images by integer pixels
            im2 = imrotate(im2,rot,'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
            im2 = downsample(im2,2*scale)'; % downsample the images by 8
            im2 = downsample(im2,2*scale)';
        
            %t3=[normrnd(0,15),normrnd(0,15),normrnd(0,15)];
            %im3 = imtranslate(im,[-t3(3)*2*scale,-t3(2)*2*scale]); % shift the images by integer pixels
            %im3 = imrotate(im3,t3(1),'bicubic','crop'); % rotate the images
            %im3 = downsample(im3,2*scale)'; % downsample the images by 8
            %im3 = downsample(im3,2*scale)';
    
    
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

            im2tB=[p(1)-p(2),d(1,1)-d(2,1),d(1,2)-d(2,2)];
            im3tB=[p(3)-p(2),d(3,1)-d(2,1),d(3,2)-d(2,2)];


            ims{1}=im3;
            ims{2}=im1;
            ims{3}=im2;

            [d,p]=keren(ims);

            im2tC=[p(3)-p(2),d(3,1)-d(2,1),d(3,2)-d(2,2)];
            im3tC=[p(1)-p(2),d(1,1)-d(2,1),d(1,2)-d(2,2)];
        
        
            %im2Ts=[(im2tA);(im2tB);(im2tC)];
            %im3Ts=[(im3tA);(im3tB);(im3tC)];

            %e=9999;

            % Min Spanning tree
            %for im2t=im2Ts.'
             %   for im3t=im3Ts.'
                    %disp(im2t.');
              %      currE=sum([getError(im1,im2,im1t,im2t.'),getError(im1,im3,im1t,im3t.'),getError(im2,im3,im2t.',im3t.')]);
               %     if currE<e
                %        e=currE;
                 %       opt{1}=im2t.';
                  %      opt{2}=im3t.';
                   % end
    
                %end   
    
            %end
            e=9999;
            r1a=[im2tA(1),im2tB(1),im2tC(1)];
            r1b=[im2tA(2),im2tB(2),im2tC(2)];
            r1c=[im2tA(3),im2tB(3),im2tC(3)];
            r2a=[im3tA(1),im3tB(1),im3tC(1)];
            r2b=[im3tA(2),im3tB(2),im3tC(2)];
            r2c=[im3tA(3),im3tB(3),im3tC(3)];
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
if im2t(1)==Inf
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