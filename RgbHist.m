%COLOR HISTOGRAM EQUALIZATION

%READ THE INPUT IMAGE
I = imread('football.jpg');
HSV = rgb2hsv(I);
Heq = histeq(HSV(:,:,3));

HSV_mod = HSV;
HSV_mod(:,:,3) = Heq;

RGB = hsv2rgb(HSV_mod);
figure,
subplot(1,2,1),imshow(I);title('Before Histogram Equalization');

subplot(1,2,2),imshow(RGB);title('After Histogram Equalization');
% RGB=uint8(RGB);
% R= RGB(:,:,1);
% G= RGB(:,:,2);
% B= RGB(:,:,3);
% RI=bitSlice(R);
% GI=bitSlice(G);
% BI=bitSlice(B);
% Img=cat(3,RI,GI,BI);
% Img=double(Img);
% figure,
% subplot(1,2,1),imshow(I),title('Original Image');
% subplot(1,2,2),imshow(Img),title('Concat Image');
