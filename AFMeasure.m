function [AFmeas] = AFMeasure(AFmeas,Aprecision,ARecall,maxk,maxrec)

for i=1:maxk
    for j=1:maxrec
        AFmeas( ((i-1) * maxrec) + j,1 )= i;
        AFmeas( ((i-1) * maxrec) + j,2 )= j;
        
        AFmeas( ((i-1) * maxrec) + j,3 )= 2 / ( (1/Aprecision( ((i-1) * maxrec) + j,3 )) + (1/ARecall( ((i-1) * maxrec) + j,3 )) );
        AFmeas( ((i-1) * maxrec) + j,4 )= 2 / ( (1/Aprecision( ((i-1) * maxrec) + j,4 )) + (1/ARecall( ((i-1) * maxrec) + j,4 )) );
        AFmeas( ((i-1) * maxrec) + j,5 )= 2 / ( (1/Aprecision( ((i-1) * maxrec) + j,5 )) + (1/ARecall( ((i-1) * maxrec) + j,5 )) );
        
        AFmeas( ((i-1) * maxrec) + j,6 )= 2 / ( (1/Aprecision( ((i-1) * maxrec) + j,6 )) + (1/ARecall( ((i-1) * maxrec) + j,6 )) );
        AFmeas( ((i-1) * maxrec) + j,7 )= 2 / ( (1/Aprecision( ((i-1) * maxrec) + j,7 )) + (1/ARecall( ((i-1) * maxrec) + j,7 )) );
        AFmeas( ((i-1) * maxrec) + j,8 )= 2 / ( (1/Aprecision( ((i-1) * maxrec) + j,8 )) + (1/ARecall( ((i-1) * maxrec) + j,8 )) );
    end
end

end

