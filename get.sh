#!/bin/bash 

# check that we have two arguments
if [ $# -ne 2 ]
then
  echo "Wrong number arguments."
  echo "How to used this script:"
  echo
  echo "   $ ./get.sh [runs.txt] [bmtdrift.txt]"
  echo
  echo "The first argument (runs.txt) must be a txt file containing the list of runs with their start times obtained with getRunsRCDB.py"
  echo "The second argument (bmtdrift.txt) must be a txt file containing the name of the slow control variables of interest"
  exit 1
fi

RUNS=$1
BMT_NAMES=$2

if [ ! -f "$RUNS" ]
then
  echo "ERROR: $RUNS not found"
  exit 1
fi

if [ ! -f "$BMT_NAMES" ]
then
  echo "ERROR: $BMT_NAMES not found"
  exit 1
fi

############################################
# function that helps adding an offset to the timestamps
function addtime () 
{
    T=$1
    echo $(gawk '
      function timeadd(t, s){
              gsub(/[-T:]/," ", t); return strftime("%Y-%m-%d %H:%M:%S", mktime(t)+s)
                 }
      BEGIN{
            print timeadd(ARGV[1], ARGV[2])
      }
      ' ${T/ /T} $2)
}

############################################

### MAIN 

# clean old files
while read line
do 
  ch=$(echo $line | cut -d: -f1)
  if [ -f ${ch}.txt ]
  then
    rm ${ch}.txt
  fi
done < $BMT_NAMES

# some cool effect for the progress bar
nruns=$(wc -l $RUNS)
irun=0

function bar () {
        k=$( echo "$1*100/$2" | bc )
        echo -n "[ "
        for ((i = 0 ; i <= k; i++)); do echo -n "#"; done
        for ((j = i ; j <= 100 ; j++)); do echo -n " "; done
        echo -n " ] "
        echo -n "$k %" $'\r'
}

# loop over the lines of the RUNS file
while read run
do

  #print some progress
  bar $irun $nruns
  let irun++
  # -----------------


  R=$(echo $run | cut -d\  -f1)
  T=$(echo $run | awk '{print $2 " " $3}')
  T2=$(addtime ${T/ /T} 600 )   # 10 minutes


# loop over the slow control variables
  while read line
  do 
    vmon=$line
    ch=$(echo $line | cut -d: -f1)
 
    # check a three different times the value and get the maximum
    HV=0
    #v=$(myget -c $vmon -b"$T" -e^20m | awk '{print $3}')
    v=$(myget -m history -c $vmon -b"$T" -e"$T2" | awk '{print $3}')
    re='^[0-9]+$'
    if ! [[ $v =~ $re ]] ; then
       # echo "error: Not a number" >&2
        v=$(myget -m history -c $vmon -t"$T2" -w- | awk '{print $3}')
    fi

    for t in ${v}
    do
        if (( $( echo $"$t > $HV" | bc -l ) ))
        then
            HV=$t
        fi
    done

    # write (append) the run and the value to the 
    echo $R $HV >> ${ch}.txt
  done < $BMT_NAMES
done < $RUNS

# final print
bar $irun $nruns
echo
