%% Script to process stomp video without processing large motions and without using all the memory
%
% Neal Wadhwa, April 2013


vidFile = inFile;
vidName = 'stomp';
outDir = resultsDir;
sigma = 12; % Blurring
alpha = 50; % Magnification
FS = 300; % Sampling rate
fl = 1; % Freq bands
fh = 25; % Freq bands

vr   = VideoReader(vidFile);




vid = vr.read();
[h,w,nC,nF] = size(vid);
toD = @(k) rgb2y(im2single(vid(:,:,:,k))); % Get luma component of a frame
getChroma = @(k) rgb2ntsc(im2single((vid(:,:,:,k))));

clear phases
clear amps

filters = getFilters([h w], 2.^[0:-1:-3], 4);
[croppedFilters, filtIDX] = getFilterIDX(filters);
buildPyr = @(im) buildSCFpyrGen(im, croppedFilters, filtIDX) ;
reconPyr = @(pyr, pind) reconSCFpyrGen(pyr, pind, croppedFilters, filtIDX);
refFrame  = 200;

tag = sprintf('alpha%d-sigma%d-band%d-%d-refFrame%d', alpha, sigma, fl, fh, refFrame);
mkdir(fullfile(outDir, tag));
vw_withLarge = VideoWriter(fullfile(outDir, sprintf('%s-%s-withlarge.avi',vidName, tag)));
vw_withLarge.Quality = 90;
vw_withLarge.FrameRate = 30;
vw_withLarge.open();
vw_withLarge.writeVideo(vid(:,:,:,1:2));


vw_withoutLarge = VideoWriter(fullfile(outDir, sprintf('%s-%s-withoutlarge.avi',vidName, tag)));
vw_withoutLarge.Quality = 90;
vw_withoutLarge.FrameRate = 30;
vw_withoutLarge.open(); 
vw_withoutLarge.writeVideo(vid(:,:,:,1:2));

[B, A] = butter(1,[fl/FS*2, fh/FS*2]); % Temporal Filter


refPyr = buildPyr(toD(refFrame));
pyr = buildPyr(toD(1));
phaseM2 = angle(pyr./refPyr);
[pyr, pind] = buildPyr(toD(2));
phaseM1 = angle(pyr./refPyr);

% Initialize butterworth filter
outPhaseM2 = phaseM2;
outPhaseM1 = phaseM1;
outPhaseM3 = phaseM1;
outPhaseM4 = phaseM1;

% Amplification
for k = 3:nF    
    fprintf('Processing frame %d\n', k);
    curPyr = buildPyr(toD(k));
    curPhase = angle(curPyr./refPyr);
    % Butterworth filter temporally
    outPhase = (B(1)*curPhase + B(2)*phaseM1 + B(3)*phaseM2 - A(2)*outPhaseM1 - A(3)*outPhaseM2)/A(1);
    phaseM2 = phaseM1;
    phaseM1 = curPhase;
    outPhaseM5 = outPhaseM4;
    outPhaseM4 = outPhaseM3;
    outPhaseM3 = outPhaseM2;
    outPhaseM2 = outPhaseM1;
    outPhaseM1 = outPhase;
    
    % Spatial Blurring    
    for band = 2:size(pind,1);
        idx = pyrBandIndices(pind,band);
        temp = pyrBand(outPhase,pind, band);
        curAmp = pyrBand(abs(curPyr), pind, band);
        temp = AmplitudeWeightedBlur(temp, curAmp, sigma);
        outPhase(idx) = temp(:);        
    end
    % Reconstruction with processing large motions
    outPhase = outPhase*(alpha);
    luma = (reconPyr(curPyr.*exp(1i*outPhase),pind));
    frame = getChroma(k);
    frame(:,:,1) = luma;
    vw_withLarge.writeVideo(im2uint8(ntsc2rgb(frame)));
    
    % Reconstruction without processing large motions
    
    % Spatiotemporally smooth phases to increase robustness
    phaseVar = (abs(outPhase)+abs(outPhaseM2)+abs(outPhaseM3)+abs(outPhaseM4)+abs(outPhaseM5))/5;
  
    for band = 2:size(pind,1);
        idx = pyrBandIndices(pind, band);
         temp = pyrBand(phaseVar,pind, band);
         curAmp = pyrBand(abs(curPyr), pind, band);
         temp = AmplitudeWeightedBlur(temp, curAmp, sigma);
         phaseVar(idx) = temp(:);
    end
             
    cutoff = pi; 
    for band = 1:3
       for or = 1:4
            idx = pyrBandIndices(pind, 1+or + 4*(band-1));
            temp = outPhase(idx);
            temp(phaseVar(idx)>cutoff/2.^band) = 0;
            outPhase(idx) = temp;
           
        end
    end
        
    luma = (reconPyr(curPyr.*exp(1i*outPhase),pind));
    frame = getChroma(k);
    frame(:,:,1) = luma;    
    vw_withoutLarge.writeVideo(im2uint8(ntsc2rgb(frame)));
    
end


vw_withLarge.close();
vw_withoutLarge.close();
