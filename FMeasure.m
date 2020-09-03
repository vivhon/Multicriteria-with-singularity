function [Fmeas] = FMeasure(AFmeas,maxk,maxrec)
Fmeas=zeros(maxk,3);
for i=1:maxk
    sum1=0;
    sum2=0;
    sum3=0;
    for j=1:maxrec
        
        sum1=sum1 + AFmeas( ((i-1) * maxrec) + j,6 ) - AFmeas( ((i-1) * maxrec) + j,3 );
        sum2=sum2 + AFmeas( ((i-1) * maxrec) + j,7 ) - AFmeas( ((i-1) * maxrec) + j,4 );
        sum3=sum3 + AFmeas( ((i-1) * maxrec) + j,8 ) - AFmeas( ((i-1) * maxrec) + j,5 );     
    end
    sum1=sum1/maxrec;
    sum2=sum2/maxrec;
    sum3=sum3/maxrec;
    Fmeas(i,1)=i;
    Fmeas(i,2)=(sum1+sum2+sum3)/3;
    Fmeas(i,3)=(sum2+sum3)/2;
end

end