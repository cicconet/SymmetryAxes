function [h,s,v] = hsv(n)
    h = linspace(0,240,n)/240;
    s = ones(size(h));
    v = s;
end