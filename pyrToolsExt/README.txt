This directory contains functions for constructing complex steerable 
pyramid filter banks and applying these filter banks to grayscale images.
The code supports pyramids with an arbitrary number of orientations and
filters per octave. It also supports our smooth radial windowing function
as specified in Appendix A of our paper:

Phase-Based Video Motion Processing
ACM Transaction on Graphics, Volume 32, Number 4 (Proceedings SIGGRAPH
2013)

The code is a rewrite of buildSCFpyr and reconSCFpyr from matlabPyrTools 
(http://www.cns.nyu.edu/lcv/software.php) maintained by Eero Simoncelli.
We take functions pyrBand.m and pyrBandIndices.m directly from that package.

Please contact Neal Wadhwa (nwadhwa@mit.edu) with any questions or concerns.
