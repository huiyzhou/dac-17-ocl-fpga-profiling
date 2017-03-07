// Copyright (C) 2013-2015 Altera Corporation, San Jose, California, USA. All rights reserved.
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
// whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// 
// This agreement shall be governed in all respects by the laws of the State of California and
// by the laws of the United States of America.
#pragma OPENCL EXTENSION cl_altera_channels : enable
channel int time_ch[2] __attribute__((depth(0)));
//channel int time_ch2 __attribute__((depth(0)));
channel int  seq_ch __attribute__((depth(0)));

 // ACL kernel for adding two input vectors
__kernel void vector_add(__global const float * restrict x, 
                         __global const float * restrict y, 
                         __global float *restrict z, const unsigned int num,
			 __global int *restrict info1, __global int *restrict info2,
			 __global int *restrict info3, __global int *restrict info4, __global int *restrict info5)
{
	
    int k = get_global_id(0);
    int l = k * num;	

    int start_t, end_t;
    int index;
    float sum;
    bool ok1, ok2;
    start_t = 0;
 
	l = k * num;	  
	sum = 0;
        for(int i = 0; i < num; i++)
        {
            sum += x[i+l] * y[i];
	    
	    if(i < 10)
	    {
		int seq = read_channel_altera(seq_ch);
	        info3[seq] = read_channel_altera(time_ch[0]);
		info4[seq] = k;
		info5[seq] = i;
	    }	    
        }
        z[k] = sum;
        end_t = read_channel_altera(time_ch[1]);//, &ok1);

        info1[k] = start_t;
        info2[k] = end_t;	 

}

__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
kernel void timer_srv(void)
{
    int count;    
    count = 0;
    
    while(1){
       bool success;
       count++;
       success = write_channel_nb_altera(time_ch[0], count);
    }  
}
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
kernel void timer_srv2(void)
{
    int count;    
    count = 0;
    
    while(1){
       bool success;
       count++;
       success = write_channel_nb_altera(time_ch[1], count);
    }  
}

__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
kernel void seq_srv (void)
{
    int count = 0;
    
    while(1){
       count++;
       write_channel_altera(seq_ch, count); 
    }  
}
/*
__attribute__((max_global_work_dim(0)))
__attribute__((autorun))
kernel void seq_srv (void)
{
    int count = 0;
    
    while(1){
       bool success;
       count++;
       success = write_channel_nb_altera(seq_ch, count);
       if(!success)
         count--;
    }  
}
*/