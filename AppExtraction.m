function [rectxt] = AppExtraction(I,siz,b)
if nargin == 2
    b = 1;
end
bsiz = 8*siz;
n = numel(I);
if bsiz > n
    error('Size of text given exceeds the maximum that can be embedded in the image')
    return
end
dim = size(I);
addl = n-bsiz;
I1 = reshape(I,1,n);
I2 = round(abs(I1(1:bsiz)));
p = 2^b;
h = 2^(b-1);
rb = zeros(1,bsiz);
for k = 1:bsiz
    I2(k) = round(I2(k));
    r = rem(I2(k),p);
    if r >= h 
        rb(k) = 1;
    end
end
rbi = (dec2bin(rb,1))';
rbin = reshape(rbi,siz,8);
rectxt = (bin2dec(rbin))';
return