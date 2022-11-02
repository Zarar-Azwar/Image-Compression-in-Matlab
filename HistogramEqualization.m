function[NI]=HistogramEqualization(IM)

[r,c]=size(IM);
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
NI=uint8(NI);
end


            
