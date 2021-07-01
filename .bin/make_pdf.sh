#!/usr/bin/env bash

# make_pdf - script to produce pdf file out of presentations

if [ "$1" != "" ]; then
    echo "Positional parameter 1 contains something"
    unoconv -f pdf "$1"
else
    echo "Positional parameter 1 is empty"
fi
