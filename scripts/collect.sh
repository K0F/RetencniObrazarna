#!/bin/bash
while :
do
find ./tmp -name "*.jpg" -exec mv {} ./out \; & find ./tmp -name "*.png" -exec mv {} ./out \;
sleep 1
done
