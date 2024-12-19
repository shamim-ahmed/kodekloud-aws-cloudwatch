#!/bin/bash

for i in {1..50}; do
    aws lambda invoke --function-name HelloWorldFunction01 --payload '{}' output.txt
    aws lambda invoke --function-name HelloWorldFunction02 --payload '{}' output.txt
    aws lambda invoke --function-name HelloWorldFunction03 --payload '{}' output.txt
done
