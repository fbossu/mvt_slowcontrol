
import matplotlib.pyplot as plt
import numpy as np

import sys

if len( sys.argv ) < 3 :
  print( "Too few arguments. Specify intial and final range")
  exit(1)

runI = int( sys.argv[1] )
runF = int( sys.argv[2] )

print( runI, runF)  

Ch = "DRIFT"
if len(sys.argv) > 3:
  Ch = sys.argv[-1]

fn = "B_DET_BMT_HV_SEC{}_L{}_{}.txt"

data = {}
for i in range(1,4):
  for j in range( 1,7):
    f =  fn.format(i,j,Ch)
    d = np.loadtxt( f  )
    data[i*100+j] = d[ (d[:,0] >= runI) & ( d[:,0] <= runF ) ]


fout = open( "table_{}_{}.txt".format( runI, runF ), 'w' )
for j in range(1,7):
  for i in range( 1, 4 ):

    d = data[i*100+j]

    if abs( d[0,1] - d[-1,1] ) > 10:
      print( "ERROR: S%d L%d, initial and final values are different" %( i, j ) )

    print(d[0,1], end=' ')
    fout.write( str(d[0,1])+" ")
  print()
  fout.write('\n')

fout.close()
