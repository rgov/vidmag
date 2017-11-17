function delta = differenceOfIIR(delta, rl, rh)
    timeDimension = 3;
    len = size(delta, timeDimension);
    lowpass1 = delta(:,:,1);
    lowpass2 = lowpass1;    
    delta(:,:,1) = 0;
    for i = 2:len       
        lowpass1 = (1-rh)*lowpass1 + rh*delta(:,:,i);
        lowpass2 = (1-rl)*lowpass2 + rl*delta(:,:,i);
        delta(:,:,i) = lowpass1-lowpass2;   
    end
end

