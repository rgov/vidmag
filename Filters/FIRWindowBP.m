function delta = FIRWindowBP(delta,  fl, fh )
    timeDimension = 3;
    len = size(delta,3);
    fl = fl*2; %Scale to be fraction of Nyquist frequency
    fh = fh*2;
    B = fir1(len, [fl, fh]);
    
    M = size(delta,1);
    batches = 20;    
    batchSize = ceil(M/batches);
    B = B(1:len);
    temp = fft(ifftshift(B));
    transferFunction(1,1,:) = temp;
    for k = 1:batches
        idx = 1+batchSize*(k-1):min(k*batchSize, M);
        freqDom = fft(delta(idx,:,:), [], timeDimension);
        freqDom = freqDom.*repmat(transferFunction,[size(freqDom,1), size(freqDom, 2)]);
        delta(idx,:,:) = real(single(ifft(freqDom,[],timeDimension)));
    end            
end

