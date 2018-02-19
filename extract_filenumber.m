function [filenumber] = extract_filenumber(filename)

filename = regexprep(filename, '\.[^\.]*$', '');

n = length(filename);

c1 = 1;

for i = n:-1:1
    if isstrprop(filename(i),'digit') == 1
        filenumber(c1) = filename(i);
    else
        break
    end
c1 = c1 + 1;
end

filenumber=str2double(fliplr(filenumber));