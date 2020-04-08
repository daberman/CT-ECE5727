#include "hls_video.h"

//Software abstractization of the AXI-Stream interface
typedef ap_axiu<24,1,1,1> interface_t;
//Wrapper type with stream-type access restrictions
typedef hls::stream<interface_t> stream_t;

//Frame resolution
#define MAX_HEIGHT 720
#define MAX_WIDTH 1280

//Testbench images
#define INPUT_IMAGE "fox.bmp"
#define OUTPUT_IMAGE "fox_output.bmp"

//Mat type for OpenCV functions
typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_8UC3> rgb_img_t;

//Synthesizable function declaration
void edge_detect(stream_t& stream_in, stream_t& stream_out);
