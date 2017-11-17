function [ buildPyr, reconPyr ] = half8PyrFunctions( h,w )
    ht = maxSCFpyrHt(zeros(h,w));
    filters = getFilters([h w], 2.^[0:-0.5:-ht], 8, 'twidth', 0.5);
    [croppedFilters, filtIDX] = getFilterIDX(filters);
    buildPyr = @(im) buildSCFpyrGen(im, croppedFilters, filtIDX) ;
    reconPyr = @(pyr, pind) reconSCFpyrGen(pyr, pind, croppedFilters, filtIDX);
end

