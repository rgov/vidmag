% RES = reconSCFpyrGen(PYR, PIND, FILTERS, TWIDTH)
%
% Reconstruct image from its steerable pyramid representation, in the Fourier
% domain, as created by buildSCFpyrGen.
%
% Based on buildSCFpyr in matlabPyrTools
%
% Authors: Neal Wadhwa
% License: Please refer to the LICENCE file
% Date: July 2013
%


function res = reconSCFpyrGen(pyr, pind, subsampledFilters, filtIDX, varargin)
% Parse optional arguments
    p = inputParser;
    nFilts = max(size(subsampledFilters));

    defaultComplex = true; %Filters only span half plane
    defaultOutputIsFreqDomain = false;

    addOptional(p, 'complex', defaultComplex, @islogical);
    addOptional(p, 'outputFreqDomain', defaultOutputIsFreqDomain, @islogical);

    parse(p,  varargin{:});
    isComplex = p.Results.complex;
    isFreqDomain = p.Results.outputFreqDomain;

    % Return pyramid in the usual format of a stack of column vectors
    imdft = zeros(pind(1,:));
    N = 1;
    for k = 1:nFilts
        bandVals = pyrBand(pyr,pind,k);    
        if (and(and(isComplex, k ~= 1), k~=nFilts))        
            tempDFT = 2*fftshift(fft2(bandVals));
        else
            tempDFT = fftshift(fft2(bandVals));
        end    
        tempDFT = tempDFT.*subsampledFilters{k};

        imdft(filtIDX{k,1}, filtIDX{k,2}) = imdft(filtIDX{k,1}, filtIDX{k,2}) + tempDFT;    
    end
    if (isFreqDomain)
        res = imdft;
    else
        res =  real(ifft2(ifftshift(imdft)));
    end
end
