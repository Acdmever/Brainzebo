for i=1:50
        allt1{i}=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];
        allt2{i}=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];
        allt3{i}=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];
        allt4{i}=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];
        allt5{i}=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];
        allt6{i}=[max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30)),max(-30,min(normrnd(0,10),30))];
end

    
%im=rgb2gray(imread('image.jpg'));
%im=im2double(im);
%im=resample(im,2,1)'; % upsample the image by 2
%im=resample(im,2,1)';
%im=resample(im,2,1)';
%errsBase{1}=getBaseVals(im,allt1,allt2,allt3,allt4,allt5,allt6);
%errsTest{1}=getTestVals(im,allt2,allt3);


%im=rgb2gray(imread('image2.jpg'));
%im=im2double(im);
%im=resample(im,2,1)'; % upsample the image by 2
%im=resample(im,2,1)';
%im=resample(im,2,1)';
%errsBase{2}=getBaseVals(im,allt1,allt2,allt3,allt4,allt5,allt6);
%errsTest{2}=getTestVals(im,allt2,allt3);


im=rgb2gray(imread('image3.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{3}=getBaseVals(im,allt1,allt2,allt3,allt4,allt5,allt6);
%errsTest{3}=getTestVals(im,allt2,allt3);


im=(imread('image4.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{4}=getBaseVals(im,allt1,allt2,allt3,allt4,allt5,allt6);
%errsTest{4}=getTestVals(im,allt2,allt3);


im=rgb2gray(imread('cameraman.png'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{5}=getBaseVals(im,allt1,allt2,allt3,allt4,allt5,allt6);
%errsTest{5}=getTestVals(im,allt2,allt3);


im=(imread('120.jpg'));
im=im2double(im);
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)';
errsBase{6}=getBaseVals(im,allt1,allt2,allt3,allt4,allt5,allt6);
%errsTest{6}=getTestVals(im,allt2,allt3);


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
errsBase{7}=getBaseVals(im,allt1,allt2,allt3,allt4,allt5,allt6);
%errsTest{7}=getTestVals(im,allt2,allt3);


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
errsBase{8}=getBaseVals(im,allt1,allt2,allt3,allt4,allt5,allt6);
%errsTest{8}=getTestVals(im,allt2,allt3);


function pixE=getBaseVals(im,allt1,allt2,allt3,allt4,allt5,allt6)

    scale=4;


  

    i=1;

    
    for test=1:50
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
        
        t4=allt4{test};
        im4 = imtranslate(im,[-t4(3)*2*scale,-t4(2)*2*scale]); % shift the images by integer pixels
        im4 = imrotate(im4,t4(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
        im4 = downsample(im4,2*scale)'; % downsample the images by 8
        im4 = downsample(im4,2*scale)';
        im4s{test}=im4;
        
        t5=allt5{test};
        im5 = imtranslate(im,[-t5(3)*2*scale,-t5(2)*2*scale]); % shift the images by integer pixels
        im5 = imrotate(im5,t5(1),'bicubic','crop'); % rotate the images
        %im2 = lowpass(im2,[0.12 0.12]);
        im5 = downsample(im5,2*scale)'; % downsample the images by 8
        im5 = downsample(im5,2*scale)';
        im5s{test}=im5;
        
        t6=allt6{test};
        im6 = imtranslate(im,[-t6(3)*2*scale,-t6(2)*2*scale]); % shift the images by integer pixels
        im6 = imrotate(im6,t6(1),'bicubic','crop'); % rotate the images
        %i62 = lowpass(im2,[0.12 0.12]);
        im6 = downsample(im6,2*scale)'; % downsample the images by 8
        im6 = downsample(im6,2*scale)';
        im6s{test}=im6;
    end
    n=1;
    for ns=[0.0,0.1,0.2,0.5,1.0]   
        for test=1:50

            t1=allt1{test};    
            t2=newBase(t1,allt2{test});
            t3=newBase(t1,allt3{test});
            t4=newBase(t1,allt4{test});
            t5=newBase(t1,allt5{test});
            t6=newBase(t1,allt6{test});

            im1=imnoise(im1s{test},'gaussian',0.0,ns);
            im2=imnoise(im2s{test},'gaussian',0.0,ns);
            im3=imnoise(im3s{test},'gaussian',0.0,ns);
            im4=imnoise(im4s{test},'gaussian',0.0,ns);
            im5=imnoise(im5s{test},'gaussian',0.0,ns);
            im6=imnoise(im6s{test},'gaussian',0.0,ns);

            ims{1}=im1;
            ims{2}=im2;
            ims{3}=im3;
            ims{4}=im4;
            ims{5}=im5;
            ims{6}=im6;

            [d,p]=keren(ims);
            im1t=[0,0,0];


            im2tA=[p(2),d(2,1),d(2,2)];
            im3tA=[p(3),d(3,1),d(3,2)];
            im4tA=[p(4),d(4,1),d(4,2)];
            im5tA=[p(5),d(5,1),d(5,2)];
            im6tA=[p(6),d(6,1),d(6,2)];

            
            pE6(test,1)=sum([getError(im1,im2,im1t,im2tA),getError(im1,im3,im1t,im3tA),getError(im2,im3,im2tA,im3tA),getError(im1,im4,im1t,im4tA),getError(im2,im4,im2tA,im4tA),getError(im3,im4,im3tA,im4tA)]);
            pE6(test,1)=pE6(test,1)+sum([getError(im1,im5,im1t,im5tA),getError(im1,im6,im1t,im6tA),getError(im2,im5,im2tA,im5tA),getError(im2,im6,im2tA,im6tA),getError(im3,im5,im3tA,im5tA),getError(im3,im6,im3tA,im6tA),getError(im4,im6,im4tA,im6tA),getError(im4,im5,im4tA,im5tA),getError(im5,im6,im5tA,im6tA)]);
            sE6(test,1)=abs(t2(2)-im2tA(2))+abs(t2(3)-im2tA(3))+abs(t3(2)-im3tA(2))+abs(t3(3)-im3tA(3))+abs(t4(2)-im4tA(2))+abs(t4(3)-im4tA(3))+abs(t5(2)-im5tA(2))+abs(t5(3)-im5tA(3))+abs(t6(2)-im6tA(2))+abs(t6(3)-im6tA(3));
            rE6(test,1)=abs(t2(1)-im2tA(1))+abs(t3(1)-im3tA(1))+abs(t4(1)-im4tA(1))+abs(t5(1)-im5tA(1))+abs(t6(1)-im6tA(1));



            ims{1}=im2;
            ims{2}=im1;
            ims{3}=im3;
            ims{4}=im4;
            ims{5}=im5;
            ims{6}=im6;

            [d,p]=keren(ims);

            im2tB=newBase([p(2),d(2,1),d(2,2)],[p(1),d(1,1),d(1,2)]);
            im3tB=newBase([p(2),d(2,1),d(2,2)],[p(3),d(3,1),d(3,2)]);
            im4tB=newBase([p(2),d(2,1),d(2,2)],[p(4),d(4,1),d(4,2)]);
            im5tB=newBase([p(2),d(2,1),d(2,2)],[p(5),d(5,1),d(5,2)]);
            im6tB=newBase([p(2),d(2,1),d(2,2)],[p(6),d(6,1),d(6,2)]);

            
            

            pE6(test,2)=sum([getError(im1,im2,im1t,im2tB),getError(im1,im3,im1t,im3tB),getError(im2,im3,im2tB,im3tB),getError(im1,im4,im1t,im4tB),getError(im2,im4,im2tB,im4tB),getError(im3,im4,im3tB,im4tB)]);
            pE6(test,2)=pE6(test,2)+sum([getError(im1,im5,im1t,im5tB),getError(im1,im6,im1t,im6tB),getError(im2,im5,im2tB,im5tB),getError(im2,im6,im2tB,im6tB),getError(im3,im5,im3tB,im5tB),getError(im3,im6,im3tB,im6tB),getError(im4,im6,im4tB,im6tB),getError(im4,im5,im4tB,im5tB),getError(im5,im6,im5tB,im6tB)]);
            sE6(test,2)=abs(t2(2)-im2tB(2))+abs(t2(3)-im2tB(3))+abs(t3(2)-im3tB(2))+abs(t3(3)-im3tB(3))+abs(t4(2)-im4tB(2))+abs(t4(3)-im4tB(3))+abs(t5(2)-im5tB(2))+abs(t5(3)-im5tB(3))+abs(t6(2)-im6tB(2))+abs(t6(3)-im6tB(3));
            rE6(test,2)=abs(t2(1)-im2tB(1))+abs(t3(1)-im3tB(1))+abs(t4(1)-im4tB(1))+abs(t5(1)-im5tB(1))+abs(t6(1)-im6tB(1));


            ims{1}=im3;
            ims{2}=im1;
            ims{3}=im2;
            ims{4}=im4;
            ims{5}=im5;
            ims{6}=im6;

            [d,p]=keren(ims);

            im2tC=newBase([p(2),d(2,1),d(2,2)],[p(3),d(3,1),d(3,2)]);
            im3tC=newBase([p(2),d(2,1),d(2,2)],[p(1),d(1,1),d(1,2)]);
            im4tC=newBase([p(2),d(2,1),d(2,2)],[p(4),d(4,1),d(4,2)]);
            im5tC=newBase([p(2),d(2,1),d(2,2)],[p(5),d(5,1),d(5,2)]);
            im6tC=newBase([p(2),d(2,1),d(2,2)],[p(6),d(6,1),d(6,2)]);


            
            pE6(test,3)=sum([getError(im1,im2,im1t,im2tC),getError(im1,im3,im1t,im3tC),getError(im2,im3,im2tC,im3tC),getError(im1,im4,im1t,im4tC),getError(im2,im4,im2tC,im4tC),getError(im3,im4,im3tC,im4tC)]);
            pE6(test,3)=pE6(test,3)+sum([getError(im1,im5,im1t,im5tC),getError(im1,im6,im1t,im6tC),getError(im2,im5,im2tC,im5tC),getError(im2,im6,im2tC,im6tC),getError(im3,im5,im3tC,im5tC),getError(im3,im6,im3tC,im6tC),getError(im4,im6,im4tC,im6tC),getError(im4,im5,im4tC,im5tC),getError(im5,im6,im5tC,im6tC)]);
            sE6(test,3)=abs(t2(2)-im2tC(2))+abs(t2(3)-im2tC(3))+abs(t3(2)-im3tC(2))+abs(t3(3)-im3tC(3))+abs(t4(2)-im4tC(2))+abs(t4(3)-im4tC(3))+abs(t5(2)-im5tC(2))+abs(t5(3)-im5tC(3))+abs(t6(2)-im6tC(2))+abs(t6(3)-im6tC(3));
            rE6(test,3)=abs(t2(1)-im2tC(1))+abs(t3(1)-im3tC(1))+abs(t4(1)-im4tC(1))+abs(t5(1)-im5tC(1))+abs(t6(1)-im6tC(1));

            ims{1}=im4;
            ims{2}=im1;
            ims{3}=im2;
            ims{4}=im3;
            ims{5}=im5;
            ims{6}=im6;

            [d,p]=keren(ims);

            im2tD=newBase([p(2),d(2,1),d(2,2)],[p(3),d(3,1),d(3,2)]);
            im3tD=newBase([p(2),d(2,1),d(2,2)],[p(4),d(4,1),d(4,2)]);
            im4tD=newBase([p(2),d(2,1),d(2,2)],[p(1),d(1,1),d(1,2)]);
            im5tD=newBase([p(2),d(2,1),d(2,2)],[p(5),d(5,1),d(5,2)]);
            im6tD=newBase([p(2),d(2,1),d(2,2)],[p(6),d(6,1),d(6,2)]);

            
            pE6(test,4)=sum([getError(im1,im2,im1t,im2tD),getError(im1,im3,im1t,im3tD),getError(im2,im3,im2tD,im3tD),getError(im1,im4,im1t,im4tD),getError(im2,im4,im2tD,im4tD),getError(im3,im4,im3tD,im4tD)]);
            pE6(test,4)=pE6(test,4)+sum([getError(im1,im5,im1t,im5tD),getError(im1,im6,im1t,im6tD),getError(im2,im5,im2tD,im5tD),getError(im2,im6,im2tD,im6tD),getError(im3,im5,im3tD,im5tD),getError(im3,im6,im3tD,im6tD),getError(im4,im6,im4tD,im6tD),getError(im4,im5,im4tD,im5tD),getError(im5,im6,im5tD,im6tD)]);
            sE6(test,4)=abs(t2(2)-im2tD(2))+abs(t2(3)-im2tD(3))+abs(t3(2)-im3tD(2))+abs(t3(3)-im3tD(3))+abs(t4(2)-im4tD(2))+abs(t4(3)-im4tD(3))+abs(t5(2)-im5tD(2))+abs(t5(3)-im5tD(3))+abs(t6(2)-im6tD(2))+abs(t6(3)-im6tD(3));
            rE6(test,4)=abs(t2(1)-im2tD(1))+abs(t3(1)-im3tD(1))+abs(t4(1)-im4tD(1))+abs(t5(1)-im5tD(1))+abs(t6(1)-im6tD(1));

            
            ims{1}=im5;
            ims{2}=im1;
            ims{3}=im2;
            ims{4}=im3;
            ims{5}=im4;
            ims{6}=im6;

            [d,p]=keren(ims);

            im2tE=newBase([p(2),d(2,1),d(2,2)],[p(3),d(3,1),d(3,2)]);
            im3tE=newBase([p(2),d(2,1),d(2,2)],[p(4),d(4,1),d(4,2)]);
            im4tE=newBase([p(2),d(2,1),d(2,2)],[p(5),d(5,1),d(5,2)]);
            im5tE=newBase([p(2),d(2,1),d(2,2)],[p(1),d(1,1),d(1,2)]);
            im6tE=newBase([p(2),d(2,1),d(2,2)],[p(6),d(6,1),d(6,2)]);

            
            
            
            pE6(test,5)=sum([getError(im1,im2,im1t,im2tE),getError(im1,im3,im1t,im3tE),getError(im2,im3,im2tE,im3tE),getError(im1,im4,im1t,im4tE),getError(im2,im4,im2tE,im4tE),getError(im3,im4,im3tE,im4tE)]);
            pE6(test,5)=pE6(test,5)+sum([getError(im1,im5,im1t,im5tE),getError(im1,im6,im1t,im6tE),getError(im2,im5,im2tE,im5tE),getError(im2,im6,im2tE,im6tE),getError(im3,im5,im3tE,im5tE),getError(im3,im6,im3tE,im6tE),getError(im4,im6,im4tE,im6tE),getError(im4,im5,im4tE,im5tE),getError(im5,im6,im5tE,im6tE)]);
            sE6(test,5)=abs(t2(2)-im2tE(2))+abs(t2(3)-im2tE(3))+abs(t3(2)-im3tE(2))+abs(t3(3)-im3tE(3))+abs(t4(2)-im4tE(2))+abs(t4(3)-im4tE(3))+abs(t5(2)-im5tE(2))+abs(t5(3)-im5tE(3))+abs(t6(2)-im6tE(2))+abs(t6(3)-im6tE(3));
            rE6(test,5)=abs(t2(1)-im2tE(1))+abs(t3(1)-im3tE(1))+abs(t4(1)-im4tE(1))+abs(t5(1)-im5tE(1))+abs(t6(1)-im6tE(1));

            ims{1}=im6;
            ims{2}=im1;
            ims{3}=im2;
            ims{4}=im3;
            ims{5}=im4;
            ims{6}=im5;

            [d,p]=keren(ims);

            im2tF=newBase([p(2),d(2,1),d(2,2)],[p(3),d(3,1),d(3,2)]);
            im3tF=newBase([p(2),d(2,1),d(2,2)],[p(4),d(4,1),d(4,2)]);
            im4tF=newBase([p(2),d(2,1),d(2,2)],[p(5),d(5,1),d(5,2)]);
            im5tF=newBase([p(2),d(2,1),d(2,2)],[p(6),d(6,1),d(6,2)]);
            im6tF=newBase([p(2),d(2,1),d(2,2)],[p(1),d(1,1),d(1,2)]);



            
            
           
            
            
            pE6(test,6)=sum([getError(im1,im2,im1t,im2tF),getError(im1,im3,im1t,im3tF),getError(im2,im3,im2tF,im3tF),getError(im1,im4,im1t,im4tF),getError(im2,im4,im2tF,im4tF),getError(im3,im4,im3tF,im4tF)]);
            pE6(test,6)=pE6(test,6)+sum([getError(im1,im5,im1t,im5tF),getError(im1,im6,im1t,im6tF),getError(im2,im5,im2tF,im5tF),getError(im2,im6,im2tF,im6tF),getError(im3,im5,im3tF,im5tF),getError(im3,im6,im3tF,im6tF),getError(im4,im6,im4tF,im6tF),getError(im4,im5,im4tF,im5tF),getError(im5,im6,im5tF,im6tF)]);
            sE6(test,6)=abs(t2(2)-im2tF(2))+abs(t2(3)-im2tF(3))+abs(t3(2)-im3tF(2))+abs(t3(3)-im3tF(3))+abs(t4(2)-im4tF(2))+abs(t4(3)-im4tF(3))+abs(t5(2)-im5tF(2))+abs(t5(3)-im5tF(3))+abs(t6(2)-im6tF(2))+abs(t6(3)-im6tF(3));
            rE6(test,6)=abs(t2(1)-im2tF(1))+abs(t3(1)-im3tF(1))+abs(t4(1)-im4tF(1))+abs(t5(1)-im5tF(1))+abs(t6(1)-im6tF(1));
            
            
            im2Ts=[(im2tA);(im2tB);(im2tC);(im2tD);(im2tE);(im2tF)];
            im3Ts=[(im3tA);(im3tB);(im3tC);(im3tD);(im3tE);(im3tF)];
            im4Ts=[(im4tA);(im4tB);(im4tC);(im4tD);(im4tE);(im4tF)];
            im5Ts=[(im5tA);(im5tB);(im5tC);(im5tD);(im5tE);(im5tF)];
            im6Ts=[(im6tA);(im6tB);(im6tC);(im6tD);(im6tE);(im6tF)];


            err6=9999;

                % Min Spanning tree
            for im2t=im2Ts.'
                for im3t=im3Ts.'

                    for im4t=im4Ts.'

                        for im5t=im5Ts.'
                            for im6t=im6Ts.'
                                currE=sum([getError(im1,im2,im1t,im2t.'),getError(im1,im3,im1t,im3t.'),getError(im2,im3,im2t.',im3t.'),getError(im1,im4,im1t,im4t.'),getError(im2,im4,im2t.',im4t.'),getError(im3,im4,im3t.',im4t.')]);
                                currE=currE+sum([getError(im1,im5,im1t,im5t.'),getError(im1,im6,im1t,im6t.'),getError(im2,im5,im2t.',im5t.'),getError(im2,im6,im2t.',im6t.'),getError(im3,im5,im3t.',im5t.'),getError(im3,im6,im3t.',im6t.'),getError(im4,im6,im4t.',im6t.'),getError(im4,im5,im4t.',im5t.'),getError(im5,im6,im5t.',im6t.')]);
                                if currE<err6
                                    err6=currE;
                                    opt6{1}=im2t.';
                                    opt6{2}=im3t.';
                                    opt6{3}=im4t.';
                                    opt6{4}=im5t.';
                                    opt6{5}=im6t.';
                                end
                            end
                        end
                    end
                end   

            end

            pE6(test,7)=err6;
            sE6(test,7)=abs(t2(2)-opt6{1}(2))+abs(t2(3)-opt6{1}(3))+abs(t3(2)-opt6{2}(2))+abs(t3(3)-opt6{2}(3))+abs(t4(2)-opt6{3}(2))+abs(t4(3)-opt6{3}(3))+abs(t5(2)-opt6{4}(2))+abs(t5(3)-opt6{4}(3))+abs(t6(2)-opt6{5}(2))+abs(t6(3)-opt6{5}(3));
            rE6(test,7)=abs(t2(1)-opt6{1}(1))+abs(t3(1)-opt6{2}(1))+abs(t4(1)-opt6{3}(1))+abs(t5(1)-opt6{4}(1))+abs(t6(1)-opt6{5}(1));


        end 

        
        pixE6{1}=(pE6);
        pixE6{2}=(rE6);
        pixE6{3}=(sE6);

        pixE{1,n}=pixE6;
        n=n+1;
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

function vec=newBase(v1,v2)
    ang=-v1(1);
    x=v2(2)-v1(2);
    y=v2(3)-v1(3);
    vec(2)=(x*cosd(ang)+y*sind(ang));
    vec(3)=(-x*sind(ang)+y*cosd(ang));
    vec(1)=(v2(1)-v1(1));

end