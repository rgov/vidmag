function motionAttenuateMedianPhase(inFile, outFile, varargin)



%--------------------------------------------------------------------------
% Parameters

p = inputParser;

% Temporal window size
addOptional(p, 'WinSize', 11);

parse(p,  varargin{:});
win = p.Results.WinSize;



%--------------------------------------------------------------------------
vr = VideoReader(inFile);
frame1 = vr.read(1);
[height, width, nChannels] = size(frame1);
nFrames = vr.NumberOfFrames;
vid = vr.read();

%--------------------------------------------------------------------------
% Pyramid functions
[h,w,nC,nF] = size(vid);
[buildPyr, reconPyr] = octave4PyrFunctions(h,w);



nLevels = maxSCFpyrHt(frame1(:,:,1));
nOrients = 4;
filt = nOrients-1;
twidth = 1;

[~, pind] = buildPyr(frame1(:,:,1));
nElements = dot(pind(:,1),pind(:,2));

outVid = VideoWriter(outFile, 'Motion JPEG AVI');
outVid.Quality = 90;
outVid.open;

for i=1:nFrames
    fprintf('Processing frame %d of %d\n', i, nFrames);
    
    t0 = max(i-fix(win/2), 1); t1 = min(t0+win-1, nFrames);
    ts = t0:t1;
      
    % Read frames and transform
    frames = zeros(height, width, nChannels, length(ts));
    pyrs = zeros(nElements, length(ts));
    for j = 1:length(ts)
        frame = im2double(vid(:,:,:,ts(j)));
        
        % Convert to YIQ
        frame = rgb2ntsc(frame);
        
        frames(:,:,:,j) = frame;
        
        % Transform
        pyrs(:,j) = buildPyr(frame(:,:,1));
    end
   
    % Phase model
    meanPhase = median(angle(pyrs), 2);
    
    % Set all phases to the model and reconstrct
    pyr = pyrs(:,ts == i);
    amp = abs(pyr);
    phase = angle(pyr);
    for k = 1:size(pind,1)
        idx = pyrBandIndices(pind, k);
        phase(idx) = meanPhase(idx);
    end        
        
    % Reconstruct
    outFrame = frames(:,:,:,ts == i);
    outFrame(:,:,1) = reconPyr(exp(1i*phase) .* amp, pind);
        
    % Back to RGB
    outFrame = ntsc2rgb(outFrame);

    outVid.writeVideo(outFrame);
end


