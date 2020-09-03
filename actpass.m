function [act,pass,min,max] = actpass(data,r,crv,w)
[m,n,q]=size(data);
g=int64(m/crv);
min =g*(r-1) + 1;
if(r== crv)
    max=m;
else 
    max = g * r;
end

a=1;
b=1;

act=zeros(max-min+1,n,q);
act=nonrating(act,0,w);
clear nonrating;
pass=zeros(m-(max-min+1),n,q);
pass=nonrating(pass,0,w);
clear nonrating;
for i=1:m
        if i>= min && i<=max
            act(a,:,:) = data(i,:,:);
            a=a+1;
        else
            pass(b,:,:) = data(i,:,:);
            b=b+1;
        end
end


end
