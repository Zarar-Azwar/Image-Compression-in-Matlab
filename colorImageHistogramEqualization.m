function[RGB]=colorImageHistogramEqualization(I)
    HSV = rgb2hsv(I);
    Heq = histeq(HSV(:,:,3));
    HSV_mod = HSV;
    HSV_mod(:,:,3) = Heq;

    RGB = hsv2rgb(HSV_mod);
end