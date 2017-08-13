from itertools import product
import numpy as np

combinations = list("".join(x) for x in product('01', repeat=14))
tmpcomb=list()
for i in range(0, len(combinations)):
    tmpcomb.append(map(lambda x: int(x), list(combinations[i])))
tmpcomb=np.array(tmpcomb)
