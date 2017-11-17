This package is a MATLAB implementation of our papers

Eulerian Video Magnification for Revealing Subtle Changes in the World
ACM Transaction on Graphics, Volume 31, Number 4 (Proceedings SIGGRAPH 2012)

Phase-Based Video Motion Processing
ACM Transaction on Graphics, Volume 32, Number 4 (Proceedings SIGGRAPH 2013)

The papers, supplementary materials, and vidoes, can be found on the project web
pages:
http://people.csail.mit.edu/mrub/vidmag/
http://people.csail.mit.edu/nwadhwa/phase-video/

The code is supplied for educational purposes only. Please refer to the enclosed
LICENSE.pdf file regarding permission to use the software.  Please cite our
papers if you use any part of the code or data on the project web pages. 

For questions/feedback/bugs, or if you would like to make commercial use of this
software, please contact:

Neal Wadhwa <nwadhwa@mit.edu>
Michael Rubinstein <mrub@mit.edu>
Computer Science and Artificial Intelligence Lab, Massachusetts Institute of Technology

Oct 23 2013



1. Tips for recording and processing videos:
============================================

At capture time:
- Minimize extraneous motion. Put the camera on a tripod. If appropriate,
  provide support for your subject (e.g. hand on a table, stable chair). 
- Minimize image noise. Use a camera with a good sensor, make sure there is
  enough light.
- Record in the highest spatial resolution possible and have the subject occupy
  most of the frame.  The more pixels covering the object of interest - the
better the signal you would be able to extract.
- If possible, record/store your video uncompressed. Codecs that compress frames
  independently (e.g.  Motion JPEG) are usually preferable over codecs
exploiting inter-frame redundancy (e.g. H.264) that, under some settings, can
introduce compression-related temporal signals to the video.

When Processing:
- To amplify motion, we recommend our new phase-based pipeline (SIGGRAPH 2013).
- To amplify color, use the linear pipeline (SIGGRAPH 2012).
- Choose the correct time scale that you want to amplify. For example, heart
  beats tend to occur around once per second for adults, corresponding to 1Hz,
and you can amplify content between 0.5Hz and 3Hz to be safe. The narrower the
interval, the more focused the amplification is and the less noise gets
amplified, but at the risk of missing physical phenomena.
- Don't forget to account for the video frame rate when specifying the temporal
  passband! See our code for examples.



2. Linear Color and Motion Magnification (SIGGRAPH 2012)
================================================================

The code includes the following combination of spatial and temporal filters,
which we used to generate all the results in the paper:

	Spatial					Temporal
---------------------------------------------------------------------------
Laplacian pyramid 				Ideal bandpass
Laplacian pyramid				Butterworth bandpass
Laplacian pyramid 				Second-order IIR bandpass
Gaussian pyramid				Ideal bandpass

The code was written in MATLAB R2011b, and tested on Windows 7, Mac OSX and
Linux. It uses the pyramid toolbox by Eero Simoncelli (matlabPyrTools),
available at http://www.cns.nyu.edu/~eero/software.php.  For convenience, we
have included a copy of version 1.4 (updated Dec. 2009) of their toolbox here.
The code currently also requires MATLAB's Image Processing Toolbox. We hope to
remove this dependency in the future.

To reproduce the results shown in the paper:

1) Download the source videos from the project web page into a directory "data"
inside the directory containing this code.
2) Start up MATLAB and change directory to the location of this code.
3) (Optional) Run "make.m" to build pyramid toolbox libraries (this is REQUIRED
if using Mac OS and MATLAB newer than 2011b).
4) Run "setPath.m".
5) Run "reproduceResultSiggraph12.m" to reproduce all the results in the paper.

NOTE: Generating each of the results will take a few minutes. We have selected
parameters that result in better looking videos, however, depending on your
application, you may not need such high quality results.

The parameters we used to generate the results presented in the paper can be
found in the script "reproduceResultsSiggraph12.m". Please refer to the paper
for more detail on selecting the values for the parameters. In some cases, the
parameters reported in the paper do not exactly match the ones in the script, as
we have refined our parameters through experimentation.  Feel free to experiment
on your own!



3. Phase-Based Motion Processing (SIGGRAPH 2013)
========================================================

The code includes functions to motion magnify videos using ideal bandpass
filters in the frequency domain and arbitrary time domain LTI filters. It also
includes codes to attenuate motions.

Function                                 Description
---------------------------------------------------------------------------
phaseAmplify				 Amplifies motion with arbitrary
					 temporal filter
phaseAmplifyLargeMotions		 Amplifies small motions, but leaves 
					 large motions unchanged (stomp.avi)
motionAttenuateFixedPhase		 Attenuates motions by fixing all phases
					 to a reference frame (face.avi)
motionAttenuateMedianPhase 		 Attenuates motions by applying median
					 filter to phases (moon.avi)

To reproduce the results shown in the paper:

1) Download the source videos from the project web page into the directory
"data" inside the directory containing the code.
2) Start MATLAB and change directory to location of this code.
3) Run "setPath.m" to add directories to MATLAB's path.
4) Run "reproduceResultsSiggraph13.m" to reproduce all results in the paper. 

Notes: This script takes four hours to run on a laptop with a quad core
processor and 16GB of RAM.  To speed up running time, uncomment line 11 in
"reproduceResultsSiggraph13.m" to use the faster octave-bandwidth complex steerable
pyramid. The released code has been tuned to use less than 16GB of ram for all
of the input videos. As a result, it may be slower than the reported times in
our paper.

We allow the user to choose one of four representations: octave, half octave,
half octave with a smoother window (see appendix A of paper) and quarter octave.
It is also possible for the user to specify their own pyramids (see getFilters.m
and getFiltersSmoothWindow.m). We also allow the user to specify an arbitrary
temporal filter. See FIRWindowBP.m for an examples. 

The previous technique of Wu et al. [2012]
(http://people.csail.mit.edu/mrub/vidmag) uses an ideal bandpassing function
(ideal_bandpassing.m). These functions have two bugs: they attenuate motions in
the passband by 50% and do not approximate true ideal bandpass filter well. This
issue has been fixed in FIRWindowBP.m, which does not attenuate motions in the
passband and more closely approximates an ideal filter in the frequency domain
than ideal_bandpassing.m. As a result, all of our magnification factors (alpha)
for sequences that use the Ideal bandpass function are half of what they would
be in the linear technique. 

The sequences eye.avi, throat.avi and car_engine.avi have been preprocessed with
a filter to remove a 120Hz flicker in the illumination source.


