for i=1:10
        allt3{i}=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];
end

    
%im=rgb2gray(imread('image.jpg'));
%im=im2double(im);
%im=resample(im,2,1)'; % upsample the image by 2
%im=resample(im,2,1)';
%im=resample(im,2,1)';
%errsBase{1}=getBaseVals(im);
%errsTest{1}=getTestVals(im,allt3);


im=rgb2gray(imread('image2.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)';
%errsBase{2}=getBaseVals(im);
errsTest{2}=getTestVals(im,allt3);


im=rgb2gray(imread('image3.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
%errsBase{3}=getBaseVals(im);
errsTest{3}=getTestVals(im,allt3);


im=(imread('image4.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
%errsBase{4}=getBaseVals(im);
errsTest{4}=getTestVals(im,allt3);


im=rgb2gray(imread('cameraman.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
%errsBase{5}=getBaseVals(im);
errsTest{5}=getTestVals(im,allt3);


im=(imread('120.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
%errsBase{6}=getBaseVals(im);
errsTest{6}=getTestVals(im,allt3);


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
%errsBase{7}=getBaseVals(im);
errsTest{7}=getTestVals(im,allt3);


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
%errsBase{8}=getBaseVals(im);
errsTest{8}=getTestVals(im,allt3);

function pixE=getBaseVals(im)
    scale=4;
    i=1;
    im1 = im; % the first image is not shifted or rotated
    %im1 = lowpass(im1,[0.12 0.12]);
    im1 = downsample(im1,2*scale)'; % downsample the images by 8
    im1 = downsample(im1,2*scale)';
    for rot=-30.0:5.0:30.0
        j=1;
        
        for shift=-30.0:5.0:30.0
            im2 = imtranslate(im,[-shift*2*scale,-shift*2*scale]); % shift the images by integer pixels
            im2 = imrotate(im2,rot,'bicubic','crop'); % rotate the images
            %im2 = lowpass(im2,[0.12 0.12]);
            im2 = downsample(im2,2*scale)'; % downsample the images by 8
            im2 = downsample(im2,2*scale)';
            ims{1}=im1;
            ims{2}=im2;
            [d,p]=keren(ims);


            %sE(i,j)=abs(d(2,1)-shift)+abs(d(2,1)-shift);
            %rE(i,j)=abs(p(2)-rot);

            pixE(i,j)=getError(im1,im2,[0,0,0],[p(2),d(2,1),d(2,2)]);
            j=j+1;
        end
        i=i+1;
    end
end



function pixE=getTestVals(im,allt3)
    scale=4;


    im1 = im; % the first image is not shifted or rotated
    %im1 = lowpass(im1,[0.12 0.12]);
    im1 = downsample(im1,2*scale)'; % downsample the images by 8
    im1 = downsample(im1,2*scale)';

    
    %Create the images we will reuse through the function
    for i=1:10
        t3=allt3{i};
        im3 = imtranslate(im,[-t3(3)*2*scale,-t3(2)*2*scale]); % shift the images by integer pixels
        im3 = imrotate(im3,t3(1),'bicubic','crop'); % rotate the images
        im3 = downsample(im3,2*scale)'; % downsample the images by 8
        im3 = downsample(im3,2*scale)';
        im3s{i}=im3;
    end

    i=1;


        
    for rot=-30.0:5.0:30.0
        j=1;
        for shift=-30.0:5.0:30.0
            im2 = imtranslate(im,[-shift*2*scale,-shift*2*scale]); % shift the images by integer pixels
            im2 = imrotate(im2,rot,'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
            im2 = downsample(im2,2*scale)'; % downsample the images by 8
            im2 = downsample(im2,2*scale)';
            for test=1:10
                im3=im3s{test};


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


                im2Ts=[(im2tA);(im2tB);(im2tC)];
                im3Ts=[(im3tA);(im3tB);(im3tC)];

                e=9999;

                % Min Spanning tree
                for im2t=im2Ts.'
                    for im3t=im3Ts.'
                        %disp(im2t.');
                        currE=sum([getError(im1,im2,im1t,im2t.'),getError(im1,im3,im1t,im3t.'),getError(im2,im3,im2t.',im3t.')]);
                        if currE<e
                            e=currE;
                            opt{1}=im2t.';
                            opt{2}=im3t.';
                        end

                    end   

                end

            
                err(test)=getError(im1,im2,[0,0,0],opt{1});
                
            end
            pixE(i,j)=mean(err);
            j=j+1;
            
        end
        i=i+1;
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