I = imread('football.jpg');
hs=colorImageHistogramEqualization(I);
hs=uint8(hs);
con=I;
con=floor(con/5);
Vector=con(:);
uniqueVal=unique(Vector);
freq=histc(Vector,uniqueVal);
prob=freq/length(Vector);
dict = huffmandict(uniqueVal,prob);
imgOneD = I(:) ;
imgVal = imgOneD ;
encodedVal = huffmanenco(Vector,dict);
decodedVal = huffmandeco(encodedVal,dict);
decodedVal=decodedVal*5;
kb = 8 * 1024 ;
fprintf('Orignal Image size');
disp(numel(de2bi(imgVal))/kb) ;
fprintf('Encoding size');
disp(numel(encodedVal)/kb) ;
fprintf('Decoded size');
disp(numel(de2bi(decodedVal))/kb) ;
[row, column, numberOfColorChannels] = size(I);
input = reshape(imgVal,[row, column, numberOfColorChannels]) ;
imwrite(input,'InputImage.png');
decodedVal = uint8(decodedVal);
output = reshape(decodedVal,[row, column, numberOfColorChannels]) ;
imwrite(output,'OutputImage.png');
subplot(1,2,1),imshow(input);title('Orignal');
subplot(1,2,2),imshow(output);title('After decoded');



