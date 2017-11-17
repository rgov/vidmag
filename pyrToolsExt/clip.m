function res = clip(im, minVal, maxVal)

  if ( maxVal < minVal )
    error('MAXVAL should be less than MINVAL');
  end

  res = im;
  res(im < minVal) = minVal;
  res(im > maxVal) = maxVal;

end
