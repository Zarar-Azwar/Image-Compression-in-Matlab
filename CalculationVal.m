function[compSize,OrigSize,CompRatio]=CalculationVal(OrigI)
     [r,c]=size(OrigI);
     if size(OrigI,3)==3
         OrigSize=r*c*24;
         compSize=r*c*12;
     else
         OrigSize=r*c*8;
         compSize=r*c*4;
     end
     CompRatio=8/4;
end