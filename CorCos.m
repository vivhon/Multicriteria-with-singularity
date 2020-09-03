function [corcos]=CorCos(train,pass,ci,w)
[m1,n,q]=size(train);
[m2,~,~]=size(pass);
corcos=zeros(m1,m2);                                        % initialising correlation matrix
for d=1:q
    for i=1:m1                                                 % i is for 1st user i.e user x
        for j=1:m2                                             % j is for 2nd user i.e user y
            sum1=0;
            sum2=0;
            sum3=0;
            count=0;
            for h=1:n                                         % h is for item
                if(train(i,h,d)~= w && pass(j,h,d)~= w)      % checking whether both user i and user j have rated item h
                    sum1=sum1 + ( train(i,h,d) * pass(j,h,d) );
                    sum2=sum2 + ( train(i,h,d) * train(i,h,d) );
                    sum3=sum3 + ( pass(j,h,d) * pass(j,h,d) );
                    count=count+1;                            % no of common items
                end
            end
            if (count~=0 && count>=ci && sum2~=0 && sum3~=0) 
                corcos(i,j)=corcos(i,j) + ( sum1/( sqrt(sum2) * sqrt(sum3) ) ); % calculating cosine correlation
            else
                corcos(i,j)= corcos(i,j) + w;  % su of both i and j is zerro (ratings of all item will be zerro)
            end
        end
    end
end
corcos(:,:)= corcos(:,:)/q;
end

