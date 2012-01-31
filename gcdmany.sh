#!/bin/bash

#http://tldp.org/LDP/abs/html/ops.html
gcd ()
{
  dividend=$1             
  divisor=$2                                  
  remainder=1 
  until [ "$remainder" -eq 0 ]
  do    
    let "remainder = $dividend % $divisor"
    dividend=$divisor 
    divisor=$remainder
  done    
}     

for i in {1..50000}
do  
  gcd 9876543210987653 87923
done

echo $dividend

