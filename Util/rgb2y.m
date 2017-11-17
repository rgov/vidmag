function out = rgb2y( vid )
%RBG2Y Converts a color video or image to the luminance part of the NTSC
%colorspace
%
% Neal Wadhwa, March 2013
[h,w,nC,nF] = size(vid);
out = zeros(h,w,1,nF, class(vid));

for k = 1:nF
    temp = rgb2ntsc(vid(:,:,:,k));
    if (isa(vid, 'uint8'))
        out(:,:,1,k) = im2uint8(temp(:,:,1));
    else
        out(:,:,1,k) = temp(:,:,1);

end

end

