function [J,p0] = paintline(I,angle,displ,rgb)

% angle should be in [0,pi]
% I should be grayscale, in [0, 1]
if angle < 0 || angle > pi
    warning('angle should be in [0,pi]');
end

J = I;

minR = Inf;
maxR = -Inf;
minC = Inf;
maxC = -Inf;
if angle > pi/2 % displacement always >= 0
    if displ < 0
       warning('displ should be >= 0 for angle > pi/2');
    end
    v = [cos(angle) sin(angle)];
    vp = [-v(2) v(1)];
    p = -displ*vp;
    d = 0;
    q = round(p+d*v);
    while q(1) >= 1 && q(2) <= size(I,2)
        if q(1) <= size(I,1) && q(2) >= 1
            J(q(1),q(2),1) = rgb(1);
            J(q(1),q(2),2) = rgb(2);
            J(q(1),q(2),3) = rgb(3);
            minR = min(minR,q(1));
            minC = min(minC,q(2));
            maxR = max(maxR,q(1));
            maxC = max(maxC,q(2));
        end
        d = d+1;
        q = round(p+d*v);
    end
    d = 0;
    q = round(p-d*v);
    while q(1) <= size(I,1) && q(2) >= 1
        if q(1) >= 1 && q(2) <= size(I,2)
            J(q(1),q(2),1) = rgb(1);
            J(q(1),q(2),2) = rgb(2);
            J(q(1),q(2),3) = rgb(3);
            minR = min(minR,q(1));
            minC = min(minC,q(2));
            maxR = max(maxR,q(1));
            maxC = max(maxC,q(2));
        end
        d = d+1;
        q = round(p-d*v);
    end
else
    if angle == pi/2
        displ = -abs(displ);
    end
    v = [cos(angle) sin(angle)];
    vp = [-v(2) v(1)];
    p = displ*vp;
    d = 0;
    q = round(p+d*v);
    while q(1) <= size(I,1) && q(2) <= size(I,2)
        if q(1) >= 1 && q(2) >= 1
            J(q(1),q(2),1) = rgb(1);
            J(q(1),q(2),2) = rgb(2);
            J(q(1),q(2),3) = rgb(3);
            minR = min(minR,q(1));
            minC = min(minC,q(2));
            maxR = max(maxR,q(1));
            maxC = max(maxC,q(2));
        end
        d = d+1;
        q = round(p+d*v);
    end
end

% center point on the line
p0 = round(0.5*[minR+maxR minC+maxC]);

end