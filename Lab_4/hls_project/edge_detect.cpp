#include "edge_detect.h"

// Top function implementation to synthesize
// Arguments:
//    stream_in - AXI-Stream video input
//    stream_out - AXI-Stream video output
void edge_detect(stream_t& stream_in, stream_t& stream_out)
{
  //hls::Mat-type local variables for intermediate results
  //pragma stream depth tells tools that no buffering is needed
	 	rgb_img_t img0(MAX_HEIGHT, MAX_WIDTH);
	#pragma HLS STREAM variable=img0 depth=1 dim=1
		rgb_img_t img1(MAX_HEIGHT, MAX_WIDTH);
	#pragma HLS STREAM variable=img1 depth=1 dim=1
		rgb_img_t img2(MAX_HEIGHT, MAX_WIDTH);
	#pragma HLS STREAM variable=img2 depth=1 dim=1
		rgb_img_t img3(MAX_HEIGHT, MAX_WIDTH);
	#pragma HLS STREAM variable=img3 depth=1 dim=1

  //Interpret AXI-Stream interface and pull the frame from it
	hls::AXIvideo2Mat(stream_in, img0);
  //Convert to grayscale
	hls::CvtColor<HLS_RGB2GRAY>(img0, img1);
  //Run the Sobel operator on the x-axis with a 3x3 kernel
	hls::Sobel<1,0,3>(img1, img2);
  //Convert back to RGB format for display purposes
	hls::CvtColor<HLS_GRAY2RGB>(img2, img3);
  //Pack the frame back into AXI-Stream interface
	hls::Mat2AXIvideo(img3, stream_out);
}
