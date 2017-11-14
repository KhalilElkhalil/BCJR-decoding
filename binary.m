function bin=binary(x,size)
i=max_bin2(x);
bin=zeros(1,size);
m=x ;
while m>0
m=m-2^i ;
bin(i+1)=1 ;
i=max_bin2(m) ;
end
z=bin ;
for jj=1:length(bin)
    z(jj)=bin(length(bin)-jj+1) ;
end
bin=z ;
end
