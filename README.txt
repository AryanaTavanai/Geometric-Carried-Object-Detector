################### Description ################### 
This program is a very basic version of the carried object detector
descibed and used in the following papers:

[1] Tavanai, Sridhar, Chinellato, Cohn, and Hogg. "Joint Tracking and 
Event Analysis for Carried Object Detection".
British Machine Vision Conference (BMVC) 2015.

[2] Tavanai, Sridhar, Gu, Cohn, Hogg . “Carried object detection and 
tracking using geometric shape models and spatio-temporal consistency,”
International Conference on Computer Vision Systems (ICVS) 2013.

It does not not reproduce the results in the paper. As most of the functionalities
in the paper have been removed, the code will produce many more false positives and
less True positives. If this code is used in your work please cite the above papers.


################### Running the code ################### 
To start the demo, open the "main.m" file with MATLAB and run it. 

A step by step demo is displayed. Two example images are provided. To
apply the code on an example of your own, place the image in the "Data" folder
along with the motion mask in the MotionMask folder.

You can find a list of parameters in the LoadParameters.m file where the important 
parameters are outlined. Tweak the parameters that best fit your dataset.

If you have any questions or bug reports please send email to
Aryana Tavanai at fy06at@leeds.ac.uk


################### Copyright ################### 
This source file is the copyright property of the University of Leeds.

Permission to use, copy, modify, and distribute this source file for
educational, research, and not-for-profit purposes, without fee and
without a signed licensing agreement, is hereby granted, provided that
the above copyright notice, this paragraph and the following three
paragraphs appear in all copies, modifications, and distributions.

In no event shall The University be liable to any party for direct,
indirect, special, incidental or consequential damages, including lost
profits, arising out of the use of this software and its documentation.

The software is provided without warranty. The University has no
obligation to provide maintenance, support, updates, enhancements, or
modifications.

This software was written by Aryana Tavanai, Computer Vision Group,
School of Computing, University of Leeds, UK. The code and use
thereof should be attributed to the author where appropriate
(including demonstrations which rely on it's use).
