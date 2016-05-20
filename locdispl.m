function LocDispl = locdispl(outerangle,X,Y,accwidth)

% displacement of (x,y) with respect to perpendicular to symmetry stencil
% (which is the symmetry line)
displacement = X*cos(outerangle)+Y*sin(outerangle);
LocDispl = accwidth/2+displacement;

end