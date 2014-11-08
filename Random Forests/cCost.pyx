from __future__ import division
import numpy as np
cimport numpy as np
DTYPE = np.int
ctypedef np.int_t DTYPE_t
cdef inline int int_max(int a, int b): return a if a >= b else b
cdef inline int int_min(int a, int b): return a if a <= b else b
# cdef inline int int_sum(int a[43]): return  a[0]+a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8]+a[9]+a[10]+a[11]+a[12]+a[13]+a[14]+a[15]+a[16]+a[17]+a[18]+a[19]+a[20]+a[21]+a[22]+a[23]+a[24]+a[30]+a[31]+a[32]+a[33]+a[34]+a[35]+a[36]+a[37]+a[38]+a[39]+a[40]+a[41]+a[42]

def costfn(np.ndarray[DTYPE_t, ndim=1] f, np.ndarray[DTYPE_t, ndim=1] g):
	assert f.dtype == DTYPE and g.dtype == DTYPE
	cdef int vmax = f.size
	cdef int smax = g.size
	cdef int freq_f[43]
	cdef int freq_g[43]
	cdef int x
	cdef float norm_f,gini_f = 0
	cdef float norm_g,gini_g = 0
	cdef float p
	
	if (vmax < 1) or (smax <1):
		return 1e10
	
	
	for x in range(43):
		freq_f[x] =0
		freq_g[x] =0
		
	for x in range(vmax):
		freq_f[f[x]] +=1
		
	for x in range(smax):
		freq_g[g[x]] +=1
	
	
	norm_f = freq_f[0]+freq_f[1]+freq_f[2]+freq_f[3]+freq_f[4]+freq_f[5]+freq_f[6]+freq_f[7]+freq_f[8]+freq_f[9]+freq_f[10]+freq_f[11]+freq_f[12]+freq_f[13]+freq_f[14]+freq_f[15]+freq_f[16]+freq_f[17]+freq_f[18]+freq_f[19]+freq_f[20]+freq_f[21]+freq_f[22]+freq_f[23]+freq_f[24]+freq_f[25]+freq_f[26]+freq_f[27]+freq_f[28]+freq_f[29]+freq_f[30]+freq_f[31]+freq_f[32]+freq_f[33]+freq_f[34]+freq_f[35]+freq_f[36]+freq_f[37]+freq_f[38]+freq_f[39]+freq_f[40]+freq_f[41]+freq_f[42]
	
	norm_g = freq_g[0]+freq_g[1]+freq_g[2]+freq_g[3]+freq_g[4]+freq_g[5]+freq_g[6]+freq_g[7]+freq_g[8]+freq_g[9]+freq_g[10]+freq_g[11]+freq_g[12]+freq_g[13]+freq_g[14]+freq_g[15]+freq_g[16]+freq_g[17]+freq_g[18]+freq_g[19]+freq_g[20]+freq_g[21]+freq_g[22]+freq_g[23]+freq_g[24]+freq_g[25]+freq_g[26]+freq_g[27]+freq_g[28]+freq_g[29]+freq_g[30]+freq_g[31]+freq_g[32]+freq_g[33]+freq_g[34]+freq_g[35]+freq_g[36]+freq_g[37]+freq_g[38]+freq_g[39]+freq_g[40]+freq_g[41]+freq_g[42]
	
	
	for x in range(43):
		p = freq_f[x]/norm_f
		gini_f += p*(1-p)
		p = freq_g[x]/norm_g
		gini_g += p*(1-p)
		
	return gini_f+gini_g