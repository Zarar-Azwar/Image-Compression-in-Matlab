rg = imread('greens.jpg');


hsv1 = rgb2hsv(rg);
%subplot(3,2,2), imshow(hsv1), title ('hsv Converted');

v1 = hsv1(:,:,3);
%subplot(3,2,3), imshow(v1), title ('Only value part');
IM=v1;

[r,c]=size(I);
I=double(IM);    
hist1=zeros(1,256);
for i=1:r
    for j=1:c
        for k=0:255
            if(I(i,j)==k)
                hist1(k+1)=hist1(k+1)+1;
            end
        end
    end
end

pdf=(1/(r*c))*hist1;

cdf=zeros(1,256);
hist2=zeros(1,256);

cdf(1)=pdf(1);
for i=2:256
    cdf(i)=cdf(i-1)+pdf(i);
end
cdf=round(255*cdf);
NI=size(I);
for i=1:r
    for j=1:c
        pix=I(i,j)+1;
        NI(i,j)=cdf(pix);
    end
end
for i=1:r
    for j=1:c
        for k=0:255
            if(NI(i,j)==k)
                hist2(k+1)=hist2(k+1)+1;
            end
        end
    end
end

%v1 = histeq(v1);
%subplot(3,2,4), imshow(v1), title ('Value part Equalized');

hsv1(:,:,3) = NI;

rgb_new = hsv2rgb(hsv1);
subplot(1,2,1), imshow(rg), title('original');
subplot(1,2,2), imshow(rgb_new), title('Equlized RGB');
