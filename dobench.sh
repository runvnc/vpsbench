#!/bin/bash

echo Enter VPS provider name
read provider

echo "Running tests.."
rm ./results >/dev/null
echo '---------'                                                                                       >results
echo 'Provider'                                                                                        >results
echo 'arg, should be VPS provider name'                                                                >results
echo '---'                                                                                             >results
echo $provider                                                                                         >results
echo '---------'                                                                                       >results
echo 'date'                                                                                            >results
echo 'date'                                                                                            >results
date                                                                                                   >results
echo '---'                                                                                             >results
echo '---------'                                                                                       >results
echo 'IP address'                                                                                      >results
echo 'ip addr show eth0 | grep inet'                                                                   >results
echo '---'                                                                                             >results
ip addr show eth0 | grep inet                                                                          >results
echo '---------'                                                                                       >results
echo 'RAM'                                                                                             >results
echo '---'                                                                                             >results
free -t -m | grep Mem                                                                                  >results
echo '---------'                                                                                       >results
echo 'CPU'                                                                                             >results
echo '(time ./gcdmany.sh) 2>&1'                                                                        >results
echo '---'                                                                                             >results
curl -s http://bench.willsave.me/gcdmany.sh > gcdmany.sh
chmod u+x gcdmany.sh
(time ./gcdmany.sh) 1> /dev/null 2>outgcd
cat outgcd | grep real | cut -f2                                                                       >results
(time ./gcdmany.sh) 2>&1                                                                               >results
echo '---------'                                                                                       >results
echo '(time curl -s http://cachefly.cachefly.net/100mb.test >/dev/null) 2>&1| grep real | cut -f2'     >results
echo 'Network'                                                                                         >results
echo '---'                                                                                             >results
(time curl -s http://cachefly.cachefly.net/100mb.test >/dev/null) 2>&1| grep real | cut -f2            >results
echo '---------'                                                                                       >results
echo 'Disk'                                                                                            >results
echo './testdisk.sh'                                                                                   >results
echo '---'                                                                                             >results
curl -s http://bench.willsave.me/testdisk.sh > testdisk.sh
chmod u+x testdisk.sh
./testdisk.sh                                                                                          >results

