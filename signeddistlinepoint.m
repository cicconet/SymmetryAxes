function d = signeddistlinepoint(lineangle,pointinline,point)

% lineangle is in [0,pi)
if lineangle > pi/2
    tangle = lineangle-pi;
else
    tangle = lineangle;
end
d = dot(point-pointinline,[-sin(tangle) cos(tangle)]);

end