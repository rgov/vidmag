function [ out ] = getIDX( lomask )
%GETIDX Summary of this function goes here
%   Detailed explanation goes here
aboveZero = lomask>0;
dim1 = sum(aboveZero,2)>0;
dim2 = sum(aboveZero,1)>0;
dims = size(lomask);
idx1 = 1:dims(1);
idx2 = 1:dims(2);

idx1 = idx1(dim1);
%idx1 = idx1-1;
%idx1(end+1) = idx1(end)+1;

idx2 = idx2(dim2);
%idx2 = idx2-1;
%idx2(end+1) = idx2(end)+1;

out{1} = idx1;
out{2} = idx2;

end

