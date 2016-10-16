#!/bin/bash

cat << _end_ | gnuplot
set terminal postscript eps color
set output "seno"
set key right bottom
set xlabel "Iteraciones"
set ylabel "MSE"
plot 'kk2.txt' using 1:2 t "sin2" w l,

_end_