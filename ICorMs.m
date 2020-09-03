function [icorms] = ICorMs(train,pass,w,cu,d)

[m1,n,~] = size(train);
[m2,~] = size(pass);
icorms = zeros(n,n);
[icorms]=nonrating(icorms,0,w); 

    for i=1:n
        for j=1:n
            sum=0;
            count=0;
            for h =1:m1
                if train(h,i,d)~= w && train(h,j,d)~= w
                    f= train(h,i,d) - train(h,j,d);
                    if f<0
                        f= -1 * f;
                    end
                    sum=sum + f;
                    count = count + 1;
                end
            end
            for h =1:m2
                if pass(h,i,d)~= w && pass(h,j,d)~= w
                    f= pass(h,i,d) - pass(h,j,d);
                    if f<0
                        f= -1 * f;
                    end
                    sum=sum + f;
                    count = count + 1;
                end
            end
            if count > 0 && count >= cu
                icorms(i,j)=1/(1+(sum/count));
            end
        end

    end


end


