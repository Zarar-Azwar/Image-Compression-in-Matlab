function [Table]=huffmanEncoding(Vector)
      uniq=unique(Vector)
      freq=histc(Vector,uniq)
      prob=freq/length(Vector)
      p=[uniq.' prob.'];
      ps=sortrows(p,2,'descend');
      depth=0;
      for i=1:size(uniq,2)-1
          code=repmat('1',[1 depth]);
          H(i,1)= string(code+string(0))
          depth=depth+1;
      end
      H(size(uniq,2),1)=string(repmat('1',[1 depth]))
      %ps(:,3)=H(:,1);
      varName={'Pixels','Probability','Code'};
      Table=sortrows (table(ps(:,1),ps(:,2),H(:,1),'VariableNames',varName),2,'descend');
      disp(Table);   
end