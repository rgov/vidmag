function [ buildPyr, reconPyr ] = quarter8PyrFunctions( h,w )   
    filters = getFiltersSmoothWindow([h w], 8, 'filtersPerOctave', 4);
    [croppedFilters, filtIDX] = getFilterIDX(filters);
    buildPyr = @(im) buildSCFpyrGen(im, croppedFilters, filtIDX) ;
    reconPyr = @(pyr, pind) reconSCFpyrGen(pyr, pind, croppedFilters, filtIDX);
end

