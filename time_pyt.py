import eval_exp
import numpy as np
import timeit
nrun = 10

for N in [1000, 2000, 4000]:
    t1 = timeit.repeat(stmt="eval_exp.eval_exp_loop(N)", globals=globals(), number=nrun, repeat=5)
    t2 = timeit.repeat(stmt="eval_exp.eval_exp_loop_parallel(N)", globals=globals(), number=nrun, repeat=5)
    t3 = timeit.repeat(stmt="eval_exp.eval_exp_vec(N)", globals=globals(), number=nrun, repeat=5)
    print("N = {}".format(N))
    print("\tLoop evaluation: {:.1f}ms".format(np.mean(t1)*1000/nrun))
    print("\tParallel loop evaluation: {:.1f}ms".format(np.mean(t2)*1000/nrun))
    print("\tVector evaluation: {:.1f}ms".format(np.mean(t3)*1000/nrun))
