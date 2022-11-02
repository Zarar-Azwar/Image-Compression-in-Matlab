function[img]=huffmanDecoding(table,strip)
    array=table2array(table)
    X=array(:,3)
    stripLen=strlength(strip);
    
    while(stripLen~=0)
        for i=1:size(X,1)
            code=X(i);
            len=strlength(code);
            if(extractBetween(strip,1,len)==code)
                fprintf(array(i,1))
                stripLen=stripLen-len
                len
                strip=extractBetween(strip,len+1,stripLen)
                img=strip;
            end
        end
    end

end