% [ANGLE, RAD] = getPolarGrid(DIMENSIONS)
% 
% Constructs rectangular grids ANGLE and RAD of dimension DIMENSIONS such 
% that ANGLE and RAD are polar coordinates (theta and r respective) of the
% points on the grid with origin at the center of the grid. 
%
% Based on buildSCFpyr in matlabPyrTools
%
% Authors: Neal Wadhwa
% License: Please refer to the LICENCE file
% Date: July 2013
%

function [ angle, rad ] = getPolarGrid( dimension )
    center = ceil((dimension+0.5)/2);

    % Create rectangular grid
    [xramp,yramp] = meshgrid( ([1:dimension(2)]-center(2))./(dimension(2)/2), ...
        ([1:dimension(1)]-center(1))./(dimension(1)/2) );
    % Convert to polar coordinates
    angle = atan2(yramp,xramp);
    rad = sqrt(xramp.^2 + yramp.^2);
    % Eliminate places where rad is zero, so logarithm is well defined
    rad(center(1),center(2)) =  rad(center(1),center(2)-1);
end

