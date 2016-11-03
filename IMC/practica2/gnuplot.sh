#!/bin/bash

cat << _end_ | gnuplot
set terminal postscript eps color
set output "seno"
set key right bottom
set xlabel "Iteraciones"
set ylabel "MSE"
plot 'errores.txt' using 1:2 t "errorTrain" w l, 'errores.txt' using 1:3 t "errorTest" w l,

_end_