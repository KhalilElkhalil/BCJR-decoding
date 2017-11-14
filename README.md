# BCJR-decoding
This algorithm is reserved to the implementation of the Bahl, Cocke, Jelinek and Raviv (BCJR) algorithm. This function takes as input the channel output (corrupted data) and the a priori prob (we will set it to 1/2) and returns as output the APP Log Likelihood Ratio (LLR) for every data input. It is usually called a Soft Input Soft Output (SISO) decoder. It can be applied to any code % having a finite state machine, in our case we will use it for rate-1/n convolutional codes.
# Copyright (c) Khalil Elkhalil
# Contact Persons: Khalil Elkhalil
# E-mail: khalil.elkhalil@kaust.edu.sa
