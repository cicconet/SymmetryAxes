function [Unique0piAngles,UniqueAngIndices,UniqueAngSigns] = uniqueangles(outerangles,innerangles)

Unique0piAngles = [];
UniqueAngIndices = zeros(length(outerangles),length(innerangles),2);
UniqueAngSigns = zeros(length(outerangles),length(innerangles),2);
for oai = 1:length(outerangles)
    outerangle = outerangles(oai);
    for iai = 1:length(innerangles)
        innerangle = innerangles(iai);
        ang1 = mod(outerangle+innerangle,2*pi);
        ang2 = mod(outerangle-innerangle+pi,2*pi);
        angs = [ang1 ang2];
        for i = 1:2
            if angs(i) > pi
                t_ang = angs(i)-pi;
                t_sgn = -1;
            else
                t_ang = angs(i);
                t_sgn = 1;
            end
            
            UniqueAngSigns(oai,iai,i) = t_sgn;
            
            if isempty(Unique0piAngles)
                Unique0piAngles = [Unique0piAngles t_ang];
                UniqueAngIndices(oai,iai,i) = 1; 
            else            
                [m,im] = min(abs(Unique0piAngles-t_ang));
                if m > pi/64 % t_ang is not in Unique0piAngles yet
                    Unique0piAngles = [Unique0piAngles t_ang];
                    UniqueAngIndices(oai,iai,i) = length(Unique0piAngles);
                else
                    UniqueAngIndices(oai,iai,i) = im;
                end
            end
        end
    end
end

end