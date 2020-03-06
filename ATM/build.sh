#!/bin/bash

if [ $1 = "all" ]; then
  make all
elif [ $1 = "clean"]; then
  make clean
else
  make clean all
fi

