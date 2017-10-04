# CNN
Implementation of CNN using Verilog for object detection.

The algorithm has 2 stages of convolution and one maxpooling layer. 
In the first stage of the convolution, test image and test pattern are convoluted with the laplacian filter.
In the second stage of convolution, outputs from the above step are colvolved with each other.
Max Pooling layer is applied on the output from the above step.

Using thresholding, the number of times the pattern appeaars in the image is calculated.
