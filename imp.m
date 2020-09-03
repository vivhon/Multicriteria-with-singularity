function [data] = imp()

rat = importfile("yahoo-data.data");

% rat=rat(1:500,:);
[m1,~]=size(rat);
m=rat(1,1);
n=rat(1,7);
for i=1:m1
    if rat(i,1)>m
        m=rat(i,1);
    end
    if rat(i,7)>n
        n=rat(i,7);
    end
end
%==========================================================================

data=zeros(m,n,5);
for i=1:m1
        data(rat(i,1),rat(i,7),1)=rat(i,2);       
        data(rat(i,1),rat(i,7),2)=rat(i,3);    
        data(rat(i,1),rat(i,7),3)=rat(i,4);    
        data(rat(i,1),rat(i,7),4)=rat(i,5);    
        data(rat(i,1),rat(i,7),5)=rat(i,6);    
end

end

