#!/bin/bash

echo enter the date

read date

echo enter the month

read month

echo enter the year

read year

rm /home/smahmud/WRF/gfs-anl/*.*

 wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month$date/*.grb2

if [ $date -eq 09 ]
then
  wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month'10'/*.grb2
else
if  [ $date -eq 08 ]
then 
  wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month'09'/*.grb2
else
if [ $date -gt 10 ]
then 
 wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month$((date+1))/*.grb2
 
else

  wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month'0'$((date+1))/*.grb2
  fi
 fi
fi






#echo wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month$date/*.grb2

#echo wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month$((date+1))/*.grb2
#echo wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month$((date+1))/*.grb2

