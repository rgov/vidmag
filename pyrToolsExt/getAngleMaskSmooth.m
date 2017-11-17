function anglemask = getAngleMaskSmooth(b,  nbands, angle, complexFilt)
    %% Computes anglemask for getRadialFilters3
    order = nbands-1;
    const = (2^(2*order))*(factorial(order)^2)/(nbands*factorial(2*order));

    
    
    angle = mod(pi+angle - pi*(b-1)/nbands,2*pi)-pi;        
    if (complexFilt)
        anglemask = sqrt(const)*cos(angle).^order .*(abs(angle)<pi/2);
    else
        anglemask = abs(sqrt(const)*cos(angle).^order);
    end
    
    

end

