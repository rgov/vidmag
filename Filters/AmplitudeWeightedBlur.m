function out = AmplitudeWeightedBlur( in, weight, sigma )
%AMPLITUDEWEIGHTEDBLUR Summary of this function goes here
%   Detailed explanation goes here

    if (sigma~=0)
        kernel = fspecial('gaussian', ceil(4*sigma), sigma);
        sz = size(kernel);
        weight = weight+eps;
        out = imfilter(in.*weight, kernel,'circular');
        weightMat = imfilter(weight,kernel,'circular');
        out = out./weightMat;
    else
        out = in;
    end
end

