function [U] = aggregation(U,B,k,pos,min,max)
U(min:max,pos,k)=B;
end
