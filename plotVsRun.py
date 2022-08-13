import matplotlib.pyplot as plt
import numpy as np
import sys

cath = sys.argv[-1]

#dat = np.loadtxt

fn = "B_DET_BMT_HV_SEC{}_L{}_{}.txt"


data = {}

fig = plt.figure( figsize=(16,10) )

for i in range(1,4):
  ax = fig.add_subplot( 3,1, i)
  for j in range( 1,7):
    f =  fn.format(i,j,cath)
    print(f)
    d = np.loadtxt( f  )
    data[i*100+j] = d
    plt.plot( d[:,0] , d[:,1],".-", label="S{}L{}".format(i,j) )

  plt.xticks( np.arange( d[0,0], d[-1,0], 20 ), rotation=45 )
  plt.legend(loc="lower left")
plt.tight_layout()
#plt.ion()
plt.show()



