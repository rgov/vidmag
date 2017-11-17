% [HIMASK, LOMASK] = getRadialMaskPair(R, RAD, TWIDTH)
% 
% HIMASK and LOMASK are radially symmetric windowing functions with smooth 
% falloff such that HIMASK.^2 + LOMASK.^2 = 1. The falloff is a cosine in the
% frequency domain.
% R specifies the boundary above which HIMASK is 1 and below which LOMASK
% is mostly 1. 
% TWIDTH specifies abruptness of falloff at boundary 
% RAD is the second output of getPolarGrid
%
% Based on buildSCFpyr in matlabPyrTools
%
% Authors: Neal Wadhwa
% License: Please refer to the LICENCE file
% Date: July 2013
%

function [himask, lomask ] = getRadialMaskPair( r, rad, twidth)

    log_rad  = log2(rad)-log2(r);
    
    himask = log_rad;
    himask = clip(himask, -twidth, 0 );
    himask = himask * pi/(2*twidth);
    himask = abs(cos(himask));        
    lomask = sqrt(1-himask.^2);
                
end

