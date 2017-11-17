function phaseAmplifySimple(vidFile, alpha, fl, fh, outFile, varargin)
% Eulerian motion magnification using phase manipulation in complex 
% steerable pyramids.
% This is a simple implementation we provide for refernce. It is slower and
% takes more memory, but is easier to read. It should only be used with
% small and short videos.
%
% Input:
%   vidFile - Path to video file
%   alpha - Magnification factor
%   fl - Low frequency cutoff
%   fh - High frequency cutoff
%   outFile - File name to write the result into
% 
% Requires Simoncelli's buildSCFpyr function for the complex steerable 
% pyramid transform, and reconSCFpyr to reconstruct from it.
%
% Design decisions:
%   - Amplify w.r.t some reference frame (typically the first) to make the
%     phases smaller. Otherwise discontinuities may occur when filtering phases
%     near the boundaries -pi, pi
%   - Typically processing the luminance channel only
%   - Not processing the high- and low-pass residuals. Those will just be
%     added back without modification during reconstruction
%   - Instead of filtering the complex phase e^(iw(x+delta(t))), we filter
%     on w(x+delta(t))
% 


% Load the sequence
fprintf('Reading sequence\n');
vr = VideoReader(vidFile);
seq = im2double(vr.read);
[height, width, numChannels, numFrames] = size(seq);
fprintf('Width = %d, Height = %d, Channels = %d, Frames = %d\n', height, width, numChannels, numFrames);


%--------------------------------------------------------------------------
% Parameters

p = inputParser;

% Number of pyramid levels
addOptional(p, 'numLevels', maxSCFpyrHt(seq(:,:,1,1)));
% Number of orientation (up to 16 due to Simoncelli's code)
addOptional(p, 'numOrients', 4);
% Chromatic attenuation
addOptional(p, 'chromAtten', 0);
% The frame with respect to which the differences in phases are taken
addOptional(p, 'refFrame', 1);

parse(p,  varargin{:});
numLevels = p.Results.numLevels;
numOrients = p.Results.numOrients;
chromAtten = p.Results.chromAtten;
refFrame = p.Results.refFrame;

% Don't amplify high and low residulals. Use given Alpha for all other
% subbands
magPhase = [0 repmat(alpha, [1, numLevels]) 0]'; 

% Parameter in Simoncelli's code, default to 1
twidth = 1; 


%--------------------------------------------------------------------------

% Convert to YIQ
% TODO: deal correctly with single channel videos
for ii = 1:numFrames
    seq(:,:,:,ii) = rgb2ntsc(seq(:,:,:,ii));
end

if chromAtten == 0
    isProcChannel = logical([1,0,0]);
else
    isProcChannel = logical([1,1,1]);
end

filt = numOrients-1;
[~, pind] = buildSCFpyr(seq(:,:,1,1), numLevels, filt);
numScales = (size(pind,1)-2)/numOrients + 2;
numBands = size(pind,1);
numElements = dot(pind(:,1),pind(:,2));

% Scale up magnification levels
if (size(magPhase,1) == 1)
    magPhase = repmat(magPhase,[numBands 1]);
elseif (size(magPhase,1) == numScales)
   magPhase = scaleBand2all(magPhase, numScales, numOrients); 
end


%--------------------------------------------------------------------------
% The temporal signal is the phase changes of each frame from the reference
% frame. We compute this on the fly instead of storing the transform for
% all the frames (this means we will recompute the transform again later 
% for the magnification)

fprintf('Computing phase differences\n');

deltaPhase = zeros(numElements, numFrames, numChannels);
parfor ii = 1:numFrames
    
    tmp = zeros(numElements, numChannels);
    
    for c = find(isProcChannel)
        
        % Transform the reference frame
        pyrRef = buildSCFpyr(seq(:,:,c,refFrame), numLevels, filt, twidth);
        
        % Transform the current frame
        pyrCA = buildSCFpyr(seq(:,:,c,ii), numLevels, filt, twidth);
        
        tmp(:,c) = angle(pyrCA) - angle(pyrRef);
    end
    
    deltaPhase(:,ii,:) = tmp;
end


%--------------------------------------------------------------------------
% Bandpass the phases

fprintf('Bandpassing phases\n');

deltaPhase = single(deltaPhase);
freqDom = fft(deltaPhase, [], 2);

first = ceil(fl*numFrames);
second = floor(fh*numFrames);
freqDom(:,1:first) = 0;
freqDom(:,second+1:end) = 0;
deltaPhase = real(ifft(freqDom,[],2));


%--------------------------------------------------------------------------
% Magnify

fprintf('Magnifying\n');

vw = VideoWriter(outFile, 'Motion JPEG AVI');
vw.Quality = 90;
vw.FrameRate = vr.FrameRate;
vw.open;

for ii = 1:numFrames
    ii
    
    frame = seq(:,:,:,ii);
    
    for c = find(isProcChannel)
        
        % Amplify the phase changes
        phase1 = deltaPhase(:,ii,c);
        for k = 1:size(pind,1)
            idx = pyrBandIndices(pind,k);
            phase1(idx) = phase1(idx) * magPhase(k);
        end
        
        % Attenuate the amplification in the chroma channels
        if c > 1
            phase1 = phase1 * chromAtten;
        end
        
        % Transform
        pyrCA = buildSCFpyr(seq(:,:,c,ii), numLevels, filt, twidth);
    
        % Magnify and reconstruct
        frame(:,:,c) = reconSCFpyr(exp(1i*phase1) .* pyrCA, pind,'all', 'all', twidth);
    end
    
    % Back to RGB
    frame = ntsc2rgb(frame); 
    
    writeVideo(vw, im2uint8(frame));
end

vw.close;

