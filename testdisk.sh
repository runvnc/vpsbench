#!/bin/bash

#http://kezhong.wordpress.com/2009/01/22/test-disk-performance-bash/

TIME_WRITE_START=$(date +%s)
dd if=/dev/zero of=test bs=1024 count=1000000
TIME_WRITE_END=$(date +%s)

TIME_READ_START=$(date +%s)
cat test > /dev/null
TIME_READ_END=$(date +%s)

rm test

TIME_WRITE_USED=$(($TIME_WRITE_END - $TIME_WRITE_START))
echo -n write $((1024 / $TIME_WRITE_USED))
echo MB/sec
TIME_READ_USED=$(($TIME_READ_END - $TIME_READ_START))
echo -n read $((1024 / $TIME_READ_USED))
echo MB/sec
