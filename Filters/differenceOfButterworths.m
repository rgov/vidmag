function delta = differenceOfButterworths( delta, fl, fh )   
    timeDimension = 3;
    
    [low_a, low_b] = butter(1, fl, 'low');
    [high_a, high_b] = butter(1, fh, 'low');
    
    len = size(delta,timeDimension);
    
    lowpass1 = delta(:,:,1);
    lowpass2 = lowpass1;
    prev = lowpass1;    
    delta(:,:,1) = 0;   
    for i = 2:len
        lowpass1 = (-high_b(2).*lowpass1 + high_a(1).*delta(:,:,i)+high_a(2).*prev)./high_b(1);
        lowpass2 = (-low_b(2).*lowpass2 + low_a(1).*delta(:,:,i)+low_a(2).*prev)./low_b(1);
        prev = delta(:,:,i);
        delta(:,:,i) = lowpass1-lowpass2;        
    end

end
