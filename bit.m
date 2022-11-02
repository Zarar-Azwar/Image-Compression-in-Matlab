img=imread('cameraman.tif');
A=ContrastStreching(img);
% B=bitget(A,1); figure, imshow(logical(B));title('Bit plane 1');
% B=bitget(A,2); figure, imshow(logical(B));title('Bit plane 2');
% B=bitget(A,3); figure, imshow(logical(B));title('Bit plane 3');
% B=bitget(A,4); figure, imshow(logical(B));title('Bit plane 4');
B=bitget(A,5);%  figure, imshow(logical(B));title('Bit plane 5');
C=bitget(A,6);%  figure, imshow(logical(B));title('Bit plane 6');
D=bitget(A,7);%  figure, imshow(logical(B));title('Bit plane 7');
E=bitget(A,8);% figure, imshow(logical(B));title('Bit plane 8');
F=B;
for i=1:size(B,1)
    for j=1:size(B,2)
        if(B(i,j)==1)
            F(i,j)=15;
        end
    end
end
G=C;
for i=1:size(C,1)
    for j=1:size(C,2)
        if(C(i,j)==1)
            G(i,j)=31;
        end
    end
end
H=D;
for i=1:size(D,1)
    for j=1:size(D,2)
        if(D(i,j)==1)
            H(i,j)=63;
        end
    end
end
I=E;
for i=1:size(E,1)
    for j=1:size(E,2)
        if(E(i,j)==1)
            I(i,j)=127;
        end
    end
end
figure, 
subplot(1,2,1),imshow(I+H+G+F);title('compressed');
subplot(1,2,2),imshow(A);title('Orignal Image');
