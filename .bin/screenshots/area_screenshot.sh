#!/bin/bash
path=~/Pictures/screenshots/
date=$(date +"%Y_%m_%d_%R:%S")

magick import $path$date'(area)'.png
