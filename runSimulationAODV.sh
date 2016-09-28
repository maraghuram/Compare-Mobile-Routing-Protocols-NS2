#!/bin/sh
rp="AODV"
#errModel="UniformErr"
errModel="TwoStateMarkovErr"

rate=0.5
st=`echo "$rate<=0.80" | bc -l`
while [ $st -eq 1 ]
do
    echo $rp $errModel $rate
    ns 100nodes.tcl $rp $errModel $rate
    rate=`echo "$rate+0.01"|bc`
    st=`echo "$rate<=0.80" | bc -l`
done
    

