#!/bin/sh

URL=http://people.csail.mit.edu/nwadhwa/phase-video/video/Source%20and%20Result%20Videos.zip

if which -s curl; then
  curl -o videos.zip "$URL"
else
  wget -O videos.zip "$URL"
fi

unzip -j videos.zip -x 'Source and Result Videos/results/*' -d data
rm -f videos.zip
