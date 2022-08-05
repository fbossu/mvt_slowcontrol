import numpy as np


fn = "B_DET_BMT_HV_SEC{}_L{}_DRIFT.txt"


data = {}

runs = []
all_runs = []

for i in range(1,4):
  for j in range( 1,7):
    f =  fn.format(i,j)
#print(f)
    d = np.loadtxt( f  )


    prev_val = 0;
    for (run , val) in d:
      if run > 15059 and val < 600 :
        continue
      
      if run not in all_runs:
        all_runs.append( int(run))

      if abs( val - prev_val) > 45:
#print("SEC{}_L{} : run {}  val {}".format(i,j,run, val) )
        prev_val = val
        
        run = int(run)
        if run not in runs:
          runs.append( run )

all_runs = sorted(all_runs)
runs = sorted(runs)
#print( all_runs, runs )


for i,r in enumerate(runs):

  if i+1 < len(runs):
    index = all_runs.index( runs[i+1] )
    next_run = all_runs[index-1]
  else:
    next_run = all_runs[-1]

  print( r, next_run )
