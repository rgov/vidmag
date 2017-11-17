clear;

dataDir = './data';

resultsDir = 'ResultsSIGGRAPH2013/';
mkdir(resultsDir);
defaultPyrType = 'halfOctave'; % Half octave pyramid is default as discussed in paper
scaleAndClipLargeVideos = true; % With this enabled, approximately 4GB of memory is used

% Uncomment to use octave bandwidth pyramid: speeds up processing,
% but will produce slightly different results
%defaultPyrType = 'octave'; 

% Uncomment to process full video sequences (uses about 16GB of memory)
%scaleAndClipLargeVideos = false;

%% Car Engine
inFile = fullfile(dataDir, 'car_engine.avi');
samplingRate = 400; % Hz
loCutoff = 15;    % Hz
hiCutoff = 25;    % Hz
alpha = 15;    
sigma = 3;         % Pixels
pyrType = 'octave';
if (scaleAndClipLargeVideos)
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType,'scaleVideo', 0.5);
else
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType,'scaleVideo', 1);
end
% The sequence is very large. To save on CPU time, we set
% pyramid type to 'octave'. If you have the resources or time, feel free to change it
% to 'halfOctave'

%% Crane
inFile = fullfile(dataDir, 'crane.avi');
samplingRate = 24; % Hz
loCutoff = 0.2;    % Hz
hiCutoff = 0.25;    % Hz
alpha = 100;    
sigma = 5;         % Pixels
temporalFilter = @FIRWindowBP; 
pyrType = defaultPyrType;
if (scaleAndClipLargeVideos)
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType,'temporalFilter', temporalFilter,'scaleVideo', 2/3);
else
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType,'temporalFilter', temporalFilter, 'scaleVideo', 1);
end  


% Crane Crop
inFile = fullfile(dataDir, 'crane_crop.avi');
samplingRate = 24; % Hz
loCutoff = 0.2;    % Hz
hiCutoff = 0.25;    % Hz
alpha = 75;    
sigma = 5;         % Pixels
temporalFilter = @FIRWindowBP; 

% Comparison of cropped crane
pyrType = 'octave';
phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType,'temporalFilter', temporalFilter);

pyrType = 'halfOctave';
phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType,'temporalFilter', temporalFilter);

pyrType = 'quarterOctave';
phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType,'temporalFilter', temporalFilter);

%% Eye
inFile = fullfile(dataDir,  'eye.avi');
samplingRate = 500; % Hz
loCutoff = 30;    % Hz
hiCutoff = 50;    % Hz
alpha = 75;    
sigma = 4;         % Pixels
pyrType = 'octave';

if (scaleAndClipLargeVideos)
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType, 'scaleVideo', 0.4);
else
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType, 'scaleVideo', 1);
end

% The sequence is very large. To save on memory and CPU time, we set
% pyramid type to 'octave'. If you have the resources, feel free to change it
% to 'halfOctave'

%% Trees
inFile = fullfile(dataDir, 'trees.avi');
samplingRate = 60; % Hz
alpha = 25;
sigma = 2;         % Pixels 
attenuateOtherFrequencies = true;
pyrType = defaultPyrType;

% Low frequencies
loCutoff = 0.5;    % Hz
hiCutoff = 1;    % Hz
phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'attenuateOtherFreq', attenuateOtherFrequencies,'pyrType', pyrType);

% Middle frequencies
loCutoff = 1.5;
hiCutoff = 2;
phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'attenuateOtherFreq', attenuateOtherFrequencies,'pyrType', pyrType);

%% Throat
inFile = fullfile(dataDir, 'throat.avi');
samplingRate = 1900; % Hz
loCutoff = 90;    % Hz
hiCutoff = 110;    % Hz
alpha = 100;    
sigma = 3;         % Pixels
pyrType = 'octave';

if (scaleAndClipLargeVideos)
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType, 'scaleVideo', 2/3);
else
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'pyrType', pyrType, 'scaleVideo', 1);
end

%% Woman
inFile = fullfile(dataDir, 'woman.avi');
samplingRate = 60; % Hz
sigma = 3;
alpha = 15;
attenuateOtherFrequencies = true;
pyrType = defaultPyrType;

% Low frequencies
loCutoff = 0.35;
hiCutoff = 0.71;
if (scaleAndClipLargeVideos)
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'attenuateOtherFreq', attenuateOtherFrequencies,'pyrType', pyrType, 'scaleVideo', 0.9);
else
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'attenuateOtherFreq', attenuateOtherFrequencies,'pyrType', pyrType, 'scaleVideo', 1);
end


% Middle frequencies
loCutoff = 1;
hiCutoff = 1.9;
phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'attenuateOtherFreq', attenuateOtherFrequencies,'pyrType', pyrType);


%% Jumping Boy
inFile = fullfile(dataDir, 'stomp.avi');
phaseAmplifyLargeMotions;


%% Comparisons with Wu et al.

% Baby
inFile = fullfile(dataDir, 'baby.avi');
loCutoff = 0.04;
hiCutoff = 0.4;
temporalFilter = @differenceOfIIR;
alpha = 20;
sigma = 5;
pyrType = 'quarterOctave';

if (scaleAndClipLargeVideos)
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, 1, resultsDir, 'sigma', sigma, 'pyrType', pyrType, 'temporalFilter', temporalFilter, 'scaleVideo', 0.8);
else
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, 1, resultsDir, 'sigma', sigma, 'pyrType', pyrType, 'temporalFilter', temporalFilter, 'scaleVideo', 1);
end

% Camera
inFile = fullfile(dataDir, 'camera.avi');
samplingRate = 300;
loCutoff = 36;
hiCutoff = 62;
temporalFilter = @differenceOfButterworths;
alpha = 120;
sigma = 5;
pyrType = defaultPyrType;
if (scaleAndClipLargeVideos)
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir, 'sigma', sigma, 'pyrType', pyrType, 'temporalFilter', temporalFilter, 'useFrames', [1 500]);
else
    phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir, 'sigma', sigma, 'pyrType', pyrType, 'temporalFilter', temporalFilter);
end

% Guitar
inFile = fullfile(dataDir, 'guitar.avi');
samplingRate = 600;
loCutoff = 72;
hiCutoff = 92;
alpha = 25;
sigma = 2;
pyrType = defaultPyrType;
phaseAmplify(inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma, 'pyrType', pyrType);

%% Motion Attenuation

% Moon
inFile = fullfile(dataDir, 'moon.avi');
outFile = fullfile(resultsDir, 'moon-motionAttenuated.avi');
motionAttenuateMedianPhase(inFile, outFile);


% Face
inFile = fullfile(dataDir, 'face.avi');
motAttFile = fullfile(resultsDir, 'face_motionattenuated.avi');
motionAttenuateFixedPhase(inFile, motAttFile);
amplify_spatial_Gdown_temporal_ideal(motAttFile,resultsDir,100,4,50/60,60/60,30, 1);


% Shuttle
inFile = fullfile(dataDir, 'shuttle.avi');
outFile = fullfile(resultsDir, 'shuttle-motionAttenuated.avi');
loCutoff = 0.05;
motionAttenuateLowpassPhase(inFile, outFile, loCutoff);
