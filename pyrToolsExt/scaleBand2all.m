function temp = scaleBand2all( mag, numScales, orients )

temp = zeros((numScales-2)*orients+2,size(mag,2));

temp(1,:) = mag(1,:);
for k = 1:(numScales-2)
   temp(1+(1:orients)+(k-1)*orients,:) = repmat(mag(k+1,:), [ orients, 1]);
end
temp(end,:) = mag(end,:);

