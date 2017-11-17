% ANGLEMASK = getAngleMask(B, ORIENTATIONS, ANGLE)
%
% Returns a masking function that selects for the Bth orientation of
% ORIENTATIONS orientations. The sum of the square of the masks as B ranges
% from 1 to ORIENTATIONS is equal to 1 and the angular windowing function
% is a raise cosine that approimates a Gaussian.
%
% ANGLE is the first output of getAngleRad.
%
% Based on buildSCFpyr in matlabPyrTools
%
% Authors: Neal Wadhwa
% License: Please refer to the LICENCE file
% Date: July 2013
%

function anglemask = getAngleMask(b,  orientations, angle)
    
    order = orientations-1;
    const = (2^(2*order))*(factorial(order)^2)/(orientations*factorial(2*order)); % Scaling constant
    angle = mod(pi+angle - pi*(b-1)/orientations,2*pi)-pi; % Mask angle mask
    anglemask = 2*sqrt(const)*cos(angle).^order .*(abs(angle)<pi/2);  % Make falloff smooth
    
end

