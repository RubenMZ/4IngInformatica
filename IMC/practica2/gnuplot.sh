#!/bin/bash

cat << _end_ | gnuplot
set terminal postscript eps color
set output "CCRDigits"
set key right bottom
set logscale x
set xlabel "Iteraciones"
set ylabel "CCR"
plot 'errores.txt' using 1:2 t "CRRTrain" w l, 'errores.txt' using 1:3 t "CCRTest" w l,

_end_