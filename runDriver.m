I=imread('football.jpg');
if size(I,3)==3
    hs=colorImageHistogramEqualization(I);
    his=I;
else
    his=HistogramEqualization(I);
end
[final,avglen,OrigSize,codeSize]=projectHuffmanEncoding(his);
figure,
subplot(1,2,1),imshow(I),title('uncompressed');
subplot(1,2,2),imshow(final),title('compressed');
disp(8/avglen);
