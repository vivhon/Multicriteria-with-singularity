function [U] = aggregation2(U,B,k,pos,rec,min,max)
U(min:max,pos,rec,k)=B;
end