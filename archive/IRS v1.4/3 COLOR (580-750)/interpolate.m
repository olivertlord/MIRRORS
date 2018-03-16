close all;
clear all;

tl=7;
tr=122;
bl=29;
br=51;

xint = (tr-tl)/765
yint = (bl-tl)/510

n=1

for m=1:510
    for n=1:765
    noise(m,n) = ((m*yint)-yint)+((n*xint)-xint)+tl;
    end;
end;

imagesc(noise)