function [corpe]=CorPear(train,pass,ci,w)
[m1,n,q] = size(train);
[m2,~,~] = size(pass);
corpea=zeros(q,m1,m2);   % initialising correlation matrix
corpe=zeros(m1,m2);
% =========================================================================
% Calculating mean for each user of its raiting
mean1 = mean(train,w);
mean2 = mean(pass,w);
% =========================================================================
% Calculating pearson correlation
for d=1:q
    for i=1:m1                                            % i is for 1st user i.e user x
        for j=1:m2                                        % j is 2nd user i.e user y
            sum1=0; 
            sum2=0;
            sum3=0;
            count=0;
            for h=1:n                                    % h is for item
                if(train(i,h,d)~= w && pass(j,h,d)~= w) % to check whether item h is rated by both user x and user y
                    sum1=sum1 + ( (train(i,h,d)-mean1(i,d)) * (pass(j,h,d)-mean2(j,d)) );
                    sum2=sum2 + ( (train(i,h,d)-mean1(i,d)) * (train(i,h,d)-mean1(i,d)) );
                    sum3=sum3 + ( (pass(j,h,d)-mean2(j,d)) * (pass(j,h,d)-mean2(j,d)) );
                    count=count+1;                       % no of common items rated by both user x and user y
                end
            end
            if (count~=0 && count>=ci && sum2~=0 && sum3~=0) 
                corpea(d,i,j)= ( sum1/(sqrt(sum2*sum3)) );      % calculating S-pearson correlation b/w user i and user j on item h
            else
                corpea(d,i,j)=  w; % it can be possible when su of user i and j is zerro (then mean and rating of every item will be zerro)
            end
        end
    end
end

for i=1:m1                                           
    for j=1:m2  
        count=0;
        for d=1:q
            if  corpea(d,i,j)~=w
                corpe(i,j)= corpe(i,j) + corpea(d,i,j);      
                count=count+1;
            end
        end
        if count==0
            corpe(i,j)=w;
        else
            corpe(i,j)=corpe(i,j)/count;
        end
    end
end

end

