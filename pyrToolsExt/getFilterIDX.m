% [CROPPEDFILTERS, FILTIDX] = getFilterIDX(FILTERS)
% 
% FILTIDX{k} is the set of indices in FILTERS{k} that correspond to
% non-zero values and CROPPEDFILTERS{k} is FILTERS{k} cropped to this set
% of indices. See getIDXFromFilter.
% This allows for more efficient processing in building and reconstruction
% of the pyramid.
%
% Based on buildSCFpyr in matlabPyrTools
%
% Authors: Neal Wadhwa
% License: Please refer to the LICENCE file
% Date: July 2013
%

function [croppedFilters, filtIDX] = getFilterIDX( filters )
    
    nFilts = max(size(filters));
    filtIDX = cell(nFilts, 2);    
    croppedFilters = cell(nFilts,1);
    
    for k = 1:nFilts
        indices = getIDXFromFilter(filters{k});
        filtIDX{k,1} = indices{1};
        filtIDX{k,2} = indices{2};
        croppedFilters{k} = filters{k}(indices{1}, indices{2});
    end

end

