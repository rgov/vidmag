function motionAttenuateFixedPhase(inFile, outFile, varargin)



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

[~, pind] = buildPyr(frame1(:,:,1));
nElements = dot(pind(:,1),pind(:,2));

outVid = VideoWriter(outFile, 'Motion JPEG AVI');
outVid.FrameRate = vr.FrameRate;
outVid.Quality = 90;
outVid.open;

frame1 = rgb2ntsc(im2double(frame1));
referencePyr = zeros(nElements, 3);
for c = 1:nChannels
    referencePyr(:,c) = buildPyr(frame1(:,:,c));
end
fixedPhase = angle(referencePyr);

for i=1:nFrames
    fprintf('Processing frame %d of %d\n', i, nFrames);
          
    % Read frames and transform
    frame = im2double(vid(:,:,:,i));
    frame = rgb2ntsc(frame);
    pyr = zeros(nElements, nChannels);
    for c = 1:nChannels
        pyr(:,c) = buildPyr(frame(:,:,c));
    end
    
    % Set all phases to the model and reconstrct
    
    amp = abs(pyr);
    phase = fixedPhase;
    
    outFrame = zeros(height, width, nChannels);
    for c = 1:nChannels
        outFrame(:,:,c) = reconPyr(exp(1i*phase(:,c)) .* amp(:,c), pind);
    end
        
    % Back to RGB
    outFrame = ntsc2rgb(outFrame);

    outVid.writeVideo(im2uint8(outFrame));
end
outVid.close();

