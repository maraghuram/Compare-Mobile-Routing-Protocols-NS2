#!/bin/sh

errorModel="TwoStateMarkovErr"
rate=0.5
type="jitter"
fileName=$type".txt"

st=`echo "$rate<=0.80" | bc -l`
while [ $st -eq 1 ]
do
    file1="AODV "$errorModel" "$rate".tr"
    file2="DSDV "$errorModel" "$rate".tr"
    file3="DSR "$errorModel" "$rate".tr"

    echo $rate

    t1=`awk -f $type.awk "$file1"`
    t2=`awk -f $type.awk "$file2"`
    t3=`awk -f $type.awk "$file3"`

    echo "$rate $t1 $t2 $t3" >> $fileName

    rate=`echo "$rate+0.01"|bc`
    st=`echo "$rate<=0.80" | bc -l`
done
