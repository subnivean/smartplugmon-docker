#!/usr/bin/env bash

# Read all smart plugs as listed in the `for` loop below

for i in 20 21 22 23 24 25
do
  ./read_cfsp.sh $i
done
