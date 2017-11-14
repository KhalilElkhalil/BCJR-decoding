function i=max_bin2(x)
y=2^0 ;
i=0;
if x==0
    i=0 ;
else
while x >= y
    y=y*2 ;
    i=i+1;  
end
 i=i-1 ; 
end%% 2^i=<x<=2^i+1 ;
end
