function [filenumber] = extract_filenumber(filename)

n = length(filename)

c1 = 1

for i = n-4:-1:1
    if isstrprop(str(i),'digit') == 1
        filenumber(c1) = str(i)    
    else
        break
    end
    c1 = c1 + 1;
end

filenumber=fliplr(filenumber)