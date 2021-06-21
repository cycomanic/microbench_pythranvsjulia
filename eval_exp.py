import numpy as np

#pythran export eval_exp_loop(int)
def eval_exp_loop(N):
    a = np.linspace(0, 2*np.pi, N)
    A = np.empty((N,N), dtype=np.complex128)
    for i in range(N):
        for j in range(N):
            A[i,j]  = np.exp(1j*100*np.sqrt(a[i]**2+a[j]**2))
    return A

#pythran export eval_exp_loop_parallel(int)
def eval_exp_loop_parallel(N):
    a = np.linspace(0, 2*np.pi, N)
    A = np.empty((N,N), dtype=np.complex128)
    #omp parallel for collapse(2)
    for i in range(N):
        for j in range(N):
            A[i,j]  = np.exp(1j*100*np.sqrt(a[i]**2+a[j]**2))
    return A

#pythran export eval_exp_vec(int):
def eval_exp_vec(N):
    a = np.linspace(0, 2*np.pi, N)
    return np.exp(1j*100*np.sqrt(a[:,None]**2+a[None,:]**2))
