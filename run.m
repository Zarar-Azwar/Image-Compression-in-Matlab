a=imread('football.jpg');
if size(a,3)==3
    R= a(:,:,1);
    G= a(:,:,2);
    B= a(:,:,3);
    RI=bitSlice(R);
    GI=bitSlice(G);
    BI=bitSlice(B);
    Img=cat(3,RI,GI,BI);
    %Img1=doubl
elseif size(a,3)==1
    aa=HistogramEqualization(a);
    Img=bitSlice(aa);
else
    disp("helllo");
end
subplot(1,2,1),imshow(a),title('Original Image');
subplot(1,2,2),imshow(Img),title('Concat Image');
    

