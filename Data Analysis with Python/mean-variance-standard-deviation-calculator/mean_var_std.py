import numpy as np


def calculate(list):
  if len(list) != 9:
    raise ValueError('List must contain nine numbers.')
  else:
    m = np.array(list).reshape(3, 3)
    calculations = {
      'mean': [
        np.mean(m, axis=0).tolist(),
        np.mean(m, axis=1).tolist(),
        np.mean(list)
      ],
      'variance':
      [np.var(m, axis=0).tolist(),
       np.var(m, axis=1).tolist(),
       np.var(list)],
      'standard deviation':
      [np.std(m, axis=0).tolist(),
       np.std(m, axis=1).tolist(),
       np.std(list)],
      'min':
      [np.min(m, axis=0).tolist(),
       np.min(m, axis=1).tolist(),
       np.min(list)],
      'max':
      [np.max(m, axis=0).tolist(),
       np.max(m, axis=1).tolist(),
       np.max(list)],
      'sum':
      [np.sum(m, axis=0).tolist(),
       np.sum(m, axis=1).tolist(),
       np.sum(list)]
    }
    return calculations
