function [mae,umae]=MAE(pred,test,w,d)
[m,n,~]=size(test);
sum1 = 0;
sum2 = 0;

umae=zeros(m,1);
for i=1:m
    umae1=0;
    umae2=0;
    for j=1:n
        if (pred(i,j)~=w) && (test(i,j,d)~=w)
            y= test(i,j,d) - pred(i,j);
            if y < 0 
               y = ( y * (-1) );
            end
            sum1 = sum1 + y ;
            sum2 = sum2 + 1 ;
            umae1= umae1 + y;
            umae2= umae2 + 1 ;
        end  
    end
    if umae2 ~= 0
            umae(i) = umae1/umae2;
    else
            umae(i) = 0;
    end
end
if sum2 ~= 0
    mae = ( sum1 / sum2) ;
else
    mae = 0;

end