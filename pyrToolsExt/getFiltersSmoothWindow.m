function out = getFiltersSmoothWindow(dims,  orientations, varargin )
%GETRADIALFILTERS Summary of this function goes here
%   Detailed explanation goes here
p = inputParser;

defaultComplex = true; % If true, only return filters in one half plane.
defaultCosOrder = 6;
defaultReps = 5;
defaultFiltersPerOctave = 6;
defaultHt = maxSCFpyrHt(zeros(dims));

addRequired(p, 'dims');
addRequired(p, 'orientations');
addOptional(p, 'cosOrder', defaultCosOrder); % Should be even, 6 seems optimal
addOptional(p, 'filtersPerOctave', defaultFiltersPerOctave);
addOptional(p, 'complex', defaultComplex', @islogical);
addOptional(p, 'height', defaultHt);

parse(p, dims, orientations, varargin{:});

dims = p.Results.dims;
orientations = p.Results.orientations;
cosOrder = p.Results.cosOrder;
%
complexFilt = p.Results.complex;
filtersPerOctave = p.Results.filtersPerOctave;
htOct = p.Results.height;

[angle, rad] = getPolarGrid(dims);


%% Compute Radial Filters first in 1D
%htOct = maxSCFpyrHt(zeros(dims(1),dims(2)))-3;

rad = (log2(rad));
rad = (htOct+rad)/htOct;
filts = filtersPerOctave*htOct;
%rad = rad+pi/2;
%rad = rad*(1+filts*1/(cosOrder+1)/2);
rad = rad*(pi/2+pi/7*filts);

windowFnc = @(x, center) abs(x-center)<pi/2;
radFilters = {};
count = 1;
total = zeros(dims);
const = (2^(2*cosOrder))*(factorial(cosOrder)^2)/((cosOrder+1)*factorial(2*cosOrder));
for k = filts:-1:1
   shift = pi/(cosOrder+1)*k+2*pi/7;
   radFilters{count} = sqrt(const)*cos(rad-shift).^cosOrder.*windowFnc(rad,shift);
   total = total + radFilters{count}.^2;
   count = count + 1;
end
%Compute lopass residual
center = ceil((dims+0.5)/2); 
lodims = ceil((center+0.5)/4);
% We crop the sum image so we don't also compute the high pass
totalCrop = total(center(1)-lodims(1):center(1)+lodims(1),center(2)-lodims(2):center(2)+lodims(2));
lopass = zeros(dims);
lopass(center(1)-lodims(1):center(1)+lodims(1),center(2)-lodims(2):center(2)+lodims(2)) = abs(sqrt(1-totalCrop));
% Compute high pass residual
total = total + lopass.^2;
hipass = abs(sqrt(1-total));

%% If either dimension is even, this fixes some errors
if (mod(dims(1),2) == 0) %even
   for k= 1:numel(radFilters)
      temp = radFilters{k};
      temp(1,:) = 0;
      radFilters{k} = temp;
   end
   hipass(1,:) = 1;
   lopass(1,:) = 0;
end
if (mod(dims(2),2) == 0)
   for k= 1:numel(radFilters)
      temp = radFilters{k};
      temp(:,1) = 0;
      radFilters{k} = temp;
   end
   hipass(:,1) = 1;
   lopass(:,1) = 0;
end


for k = 1:orientations
   anglemask{k} = getAngleMaskSmooth(k,orientations, angle,complexFilt); 
end

out{1}= hipass;
count = 2;
for k = 1:numel(radFilters)
    for j = 1:numel(anglemask)
        out{count} = anglemask{j}.*radFilters{k};
        count = count + 1;
    end
end
out{count} = lopass;


end
