function motionAttenuateLowpassPhase(inFile, outFile, loCutoff)
% Processing done on RGB instead of YIQ space



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
outVid.writeVideo(frame1);
frame1 = (im2double(frame1));

[B, A] = butter(1,loCutoff, 'low');

prevPhase = zeros(nElements, nChannels);
for c = 1:nChannels
   [prevPhase(:,c), pind] = buildPyr(frame1);
end
prevPhase = prevPhase./abs(prevPhase); %Filter real and imag parts of phase

prevOutPhase = prevPhase;

for i=2:nFrames
    fprintf('Processing frame %d of %d\n', i, nFrames);
          
    % Read frames and transform
    frame = im2double(vid(:,:,:,i));   
    pyr = zeros(nElements, nChannels);
    for c = 1:nChannels
        pyr(:,c) = buildPyr(frame(:,:,c));
    end
    curPhase = pyr./abs(pyr);
    curOut = (B(1)*curPhase + B(2)*prevPhase-A(2)*prevOutPhase)./A(1);
    
    idx = pyrBandIndices(pind, 26); % set lowpass phase to 1
    curOut(idx,:) = 1;
    
    prevPhase = curPhase;
    prevOutPhase = curOut;
    
    
    amp = abs(pyr);
    amp(idx,:) = pyr(idx,:); % Don't process lowpass residual
    idx = pyrBandIndices(pind,1);
    amp(idx,:) = 0; % Don't include hipass residual
    
    outFrame = zeros(height, width, nChannels);
    for c = 1:nChannels
        outFrame(:,:,c) = reconPyr(curOut(:,c) .* amp(:,c), pind);
    end
        
    % Back to RGB
    outFrame = (outFrame);

    outVid.writeVideo(im2uint8(outFrame));
end
outVid.close();

