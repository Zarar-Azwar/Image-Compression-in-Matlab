%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Functions%%
clc;
clear all;
close all;
I=imread("circuit.tif");
I=[10	20	100
10	30	30
20	100	10]

w1=5;
w2=60;
r1=20;
r2=50;
Img=ContrastStreching(I,r1,r2,w1,w2);
Img
% figure
% subplot(1,2,1),imshow(I),title('Original Image');
% subplot(1,2,2),imshow(Img),title('After Contrast Streching');
% 
% I=imread("board.tif");
% 
% w1=80;
% w2=130;
% r1=50;
% r2=150;
% Img=ContrastStreching(I,r1,r2,w1,w2);
% figure,
% subplot(1,2,1),imshow(I),title('Original Image');
% subplot(1,2,2),imshow(Img),title('After Contrast Streching');
% IM=HistogramEqualization(Img);
% figure
% imshow(IM);
I=imread('green.jpg');
h=rgbConv(I);
