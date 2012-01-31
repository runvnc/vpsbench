#!/bin/bash

TIME_WRITE_START=$(date +%s)
#dd if=/dev/zero of=test bs=1024 count=1000000
TIME_WRITE_END=$(date +%s)

dd if=/dev/urandom of=test2 bs=2024 count=200000

TIME_READ_START=$(date +%s)
cat test2 | grep lmno
#dd if=test2 of=/dev/null bs=1024
TIME_READ_END=$(date +%s)

rm test
rm test2

TIME_WRITE_USED=$(($TIME_WRITE_END - $TIME_WRITE_START))
echo -n The write disk performance: 
#echo -n write $((1024 / $TIME_WRITE_USED))
echo  MB/sec
TIME_READ_USED=$(($TIME_READ_END - $TIME_READ_START))
echo -n The read disk performance: 
echo -n $((1024 / $TIME_READ_USED))
echo  MB/sec
