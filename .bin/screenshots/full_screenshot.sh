#!/bin/bash
path=~/Pictures/screenshots/
date=$(date +"%Y_%m_%d_%R:%S")

magick import -window root $path$date'(full)'.png
