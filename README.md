# CNN
Implementation of CNN using Verilog for object detection.

The algorithm has 2 stages of convolution and one maxpooling layer. In the first stage of the convolution, test image and test pattern are convolved with the laplacian filter. In the second stage of convolution, outputs from the previous step are convolved with each other.

Max Pooling layer is applied on the output from the previous step. Using thresholding, the number of times the pattern appeaars in the image is calculated.

Detailed information about the implementation and results can be found at https://github.com/AniketBadhan/Convolutional-Neural-Network/blob/master/CNN%20Project%20Report.pdf
