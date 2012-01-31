#!/bin/bash

if [ $# -lt 1 ] ; then
  echo Specify VPS provider name
  exit 1

rm ./results
echo '---------'                                                  >results
echo 'Provider'                                                   >results
echo 'arg, should be VPS provider name'                           >results
echo '---'
echo $1                                                           >results
echo '---------'                                                  >results
echo 'date'                                                       >results
echo 'date'                                                       >results
date                                                              >results
echo '---'                                                        >results
echo '---------'                                                  >results
echo 'IP address'                                                 >results
echo 'ip addr show eth0 | grep inet'                              >results
echo '---'                                                        >results
ip addr show eth0 | grep inet                                     >results
echo '---------'                                                  >results
echo 'CPU'                                                        >results
echo 'time ./gcdmany.sh'                                          >results
echo '---'
curl -s http://bench.willsave.me/gcdmany.sh > gcdmany.sh
chmod u+x gcdmany.sh
time ./gcdmany.sh                                                 >results
echo '---------'                                                  >results
echo 'wget -O /dev/null http://cachefly.cachefly.net/100mb.test'  >results
echo 'Network'                                                    >results
echo '---'                                                        >results
wget -O /dev/null http://cachefly.cachefly.net/100mb.test 2>&1    >results
echo '---------'                                                  >results
echo 'Disk'                                                       >results
echo './testdisk.sh'                                              >results
echo '---'
curl -s http://bench.willsave.me/testdisk.sh > testdisk.sh
chmod u+x testdisk.sh
./testdisk.sh                                                     >results

