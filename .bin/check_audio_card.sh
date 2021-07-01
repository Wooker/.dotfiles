#!/usr/bin/fish

if test (lsusb | grep Rubix22)
	qjackctl &
else
	dunstify "Rubix22 is not there"
end
