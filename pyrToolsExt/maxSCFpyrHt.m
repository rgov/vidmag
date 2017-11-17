% MAXHEIGHT = maxSCFpyrHt(IM)
% 
% Specifies the maximum number of octaves that can be in a steerable
% pyramid of image IM.
%
% Based on buildSCFpyr in matlabPyrTools
%
% Authors: Neal Wadhwa
% License: Please refer to the LICENCE file
% Date: July 2013
%

function maxHeight = maxSCFpyrHt(im )
    maxHeight = floor(log2(min(size(im)))) - 2;
end

