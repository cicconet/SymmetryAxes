function J = paintsegment(I,midpointI,angleI,seglenI,rgb)

J = I;
v = [cos(angleI) sin(angleI)];
for r = 1:seglenI/2
    w = round(midpointI+r*v);
    if w(1) >= 1 && w(1) <= size(I,1) && w(2) >= 1 && w(2) <= size(I,2)
        for i = 1:3
            J(w(1),w(2),i) = rgb(i);
        end
    end
    w = round(midpointI-r*v);
    if w(1) >= 1 && w(1) <= size(I,1) && w(2) >= 1 && w(2) <= size(I,2)
        for i = 1:3
            J(w(1),w(2),i) = rgb(i);
        end
    end
end

end