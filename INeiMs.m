function [ineims] = INeiMs(icorms,ik,w)
[m,n] = size(icorms);
ineims=zeros(m,ik);
[~,p]=sort(icorms,2,'descend');
ineims=nonrating(ineims,0,w);
for i=1:m
    count=1;
    for j=1:n
        if icorms(i,p(i,j))~=w % && corms(i,p(i,j))>0
            ineims(i,count)=p(i,j);
            if count<ik
                count=count+1;
            else
                break;
            end
        end
        
    end
end
end



