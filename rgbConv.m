function [rgb_new]=rgbConv(rgb1)
    subplot(1,2,1), imshow(rgb1), title('original');
    hsv1 = rgb2hsv(rgb1);
    v1 = hsv1(:,:,3);
    v1 = histeq(v1);
    hsv1(:,:,3) = v1;
    rgb_new = hsv2rgb(hsv1);
    subplot(1,2,2), imshow(rgb_new), title('Equlized RGB');
end
