%%img=imread('cameraman.tif');
img=imread('cameraman.tif');
img=img(:);
tab=huffmanEncoding(img);
coded='';
disp(tab);
arr=table2array(tab);
X = str2double(arr(:,3));
Y=str2double(arr(:,1));
for i=1:size(img,2)
    for j=1:size(X,1)
        if(img(i)==Y(j))
            coded=coded+arr(j,3);
        end
    end
end
coded