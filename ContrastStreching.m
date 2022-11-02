function[Img]=ContrastStreching(I)
    r1=50;
    r2=180;
    w1=30;
    w2=150;
    a=w1/r1;
    b=(w2-w1)/(r2-r1);
    g=(255-w2)/(255-r1);
    if(ndims(I)==3)
        Img=I;
        [r,c,d]=size(Img);
        for k=1:d
            for i=1:r
                for j=1:c
                    if Img(i,j,k)<=r1
                        r=Img(i,j,k);
                    elseif Img(i,j,k)>r1 && Img(i,j,k)<=r2
                        r=Img(i,j,k);
                        Img(i,j,k)=(b*(r-r1))+w1;
                    else
                        r=Img(i,j,k);
                        Img(i,j,k)=(g*(r-r2))+w2;
                    end
                end
            end
        end
    elseif(ndims(I)==2 && islogical(I)==1)
        %%binary image
    else
        Img=I;
        [r,c]=size(Img);
        for i=1:r
            for j=1:c
                if Img(i,j)<=r1
                    r=Img(i,j);
                elseif Img(i,j)>r1 && Img(i,j)<=r2
                    r=Img(i,j);
                    Img(i,j)=(b*(r-r1))+w1;
                else
                    r=Img(i,j);
                    Img(i,j)=(g*(r-r2))+w2;
                end
            end
        end
    end

subplot(2,2,1),imshow(I),title('Original Image');
subplot(2,2,2),imshow(Img),title('After Contrast Streching');
subplot(2,2,3), imhist(I),title('Original Image Histogram');
subplot(2,2,4), imhist(Img),title('After Contrast Streching Histogram');
end