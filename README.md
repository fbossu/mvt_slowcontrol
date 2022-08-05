# Tools to get, analyse and save MVT slowcontrol data

### Get run start time

```
$ python getRunsRCDB.py [#run beginning] [#run end]
```

### Get data per run

```
$ ./get.sh [runs.txt] [bmtvars.txt]
```

### Plot the values as a function of run

This is useful to detect issues visually. Run it before the other scripts, so that you can cross check the results

```
$ python plotVsRun.py
```

This script requires matplotlib to be installed


### Detect changes in the values 

In order to find sub periods with constant values, we need to detect major changes in the values of the different channels

```
$ python detect_changes.py | tee changes.txt
```

It requires numpy to be installed.

*TODO*: this script works well for the drift HV. One has to modify the values to work with strip HV or other variables


### Write tables for ccdb

``` 
$ while read line; do python /writeTables.py $line; done < changes.txt

```


