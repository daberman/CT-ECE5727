#include "edge_detect.h"
#include "hls_opencv.h"

//Testbench that uses OpenCV to open a test image, wrap it in an AXI-Stream,
//pipe it into the function under test and save the result into the output image.
int main()
{
	cv::Mat src = cv::imread(INPUT_IMAGE);
	cv::Mat dst = src;

	stream_t stream_in, stream_out;
	cvMat2AXIvideo(src, stream_in);
	edge_detect(stream_in, stream_out);
	AXIvideo2cvMat(stream_out, dst);

	cv::imwrite(OUTPUT_IMAGE, dst);

	return 0;
}
