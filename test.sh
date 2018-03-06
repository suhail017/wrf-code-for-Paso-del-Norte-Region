#!/bin/bash

echo enter the date

read date

echo enter the month

read month

echo enter the year

read year

#rm /home/suhail/ts/gfs/*.*

echo wget -P /home/suhail/ts/gfs/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month$date/*.grb2

if [ $date -eq 09 ]
then
echo wget -P /home/suhail/ts/gfs/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month'10'/*.grb2
else

if  [ $date -eq 08 ]
then 
echo wget -P /home/suhail/ts/gfs/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month'09'/*.grb2

else

echo wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month'0'$((date+1))/*.grb2
  fi
fi
