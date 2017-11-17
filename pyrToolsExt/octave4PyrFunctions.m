function [ buildPyr, reconPyr ] = octave4PyrFunctions( h,w )
    ht = maxSCFpyrHt(zeros(h,w));
    filters = getFilters([h w], 2.^[0:-1:-ht], 4);
    [croppedFilters, filtIDX] = getFilterIDX(filters);
    buildPyr = @(im) buildSCFpyrGen(im, croppedFilters, filtIDX) ;
    reconPyr = @(pyr, pind) reconSCFpyrGen(pyr, pind, croppedFilters, filtIDX);
end

