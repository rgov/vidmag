function writeVideo( vid, rate, outFile,quality,profile)
%WRITEVIDEO Summary of this function goes here
%   Detailed explanation goes here

if (nargin <4)
    quality = 90;
end
if (nargin <5)
   profile = 'Motion JPEG AVI'; 
end
    

vw = VideoWriter(outFile,profile);
if (strcmp(profile, 'Motion JPEG AVI'))
    vw.Quality = quality;
end

vw.FrameRate =  rate;
vw.open;    
vw.writeVideo(im2uint8(vid));
vw.close;
end

