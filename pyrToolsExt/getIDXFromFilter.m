% FILTIDX = getIDXFrmFilter(FILTER)
%
% Returns the indices that correspond to the non-zero values in FILTER plus
% a 180 degree rotated copy of FILTER and all indices in between two
% non-zero indices.
%
% Based on buildSCFpyr in matlabPyrTools
%
% Authors: Neal Wadhwa
% License: Please refer to the LICENCE file
% Date: July 2013
%


function [ filtIDX ] = getIDXFromFilter( filter )
    aboveZero = filter>1e-10;
    dim1 = sum(aboveZero,2)>0;
    dim1 = or(dim1,rot90(dim1,2));
    dim2 = sum(aboveZero,1)>0;
    dim2 = or(dim2, rot90(dim2,2));
    dims = size(filter);
    idx1 = 1:dims(1);
    idx2 = 1:dims(2);

    idx1 = idx1(dim1);
    idx1 =min(idx1):max(idx1);

    idx2 = idx2(dim2);
    idx2 = min(idx2):max(idx2);

    filtIDX{1} = idx1;
    filtIDX{2} = idx2;

end

