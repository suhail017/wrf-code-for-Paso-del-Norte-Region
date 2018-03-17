#!/bin/bash

echo enter the date

read date

echo enter the month

read month

echo enter the year

read year

echo enter directory

read pwd

#rm /$pwd/gfs-anl/*.*

echo wget -P /$pwd/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month$date/*.grb2


sed -i '6 c\
 start_year\t\t\t     = '$year,$year,$year,''  /$pwd/WRFV3/test/em_real/namelist.input

sed -i '7 c\
 start_month\t\t\t     = '$month,$month,$month,'' /$pwd/WRFV3/test/em_real/namelist.input


sed -i '12 c\
 end_year\t\t\t     = '$year,$year,$year,''  /$pwd/WRFV3/test/em_real/namelist.input


sed -i '13 c\
 end_month\t\t\t     = '$month,$month,$month,'' /$pwd/WRFV3/test/em_real/namelist.input



if [ $date -eq 09 ]

then

echo wget -P /$pwd/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month'10'/*.grb2

sed -i '4 c\
start_date ='"'$year-$month-$date"_"06:00:00'"','"'$year-$month-$date"_"06:00:00'"','"'$year-$month-$date"_"06:00:00'"''  /$pwd/WPS/namelist.wps


sed -i '5 c\
end_date ='"'$year-$month-10"_"06:00:00'"','"'$year-$month-10"_"06:00:00'"','"'$year-$month-10"_"06:00:00'"''  /$pwd/WPS/namelist.wps


sed -i '8 c\
 start_day\t\t\t     = '$date,$date,$date,'' /$pwd/WRFV3/test/em_real/namelist.input


sed -i '14 c\
 end_day\t\t\t     =''10','10','10'',' /$pwd/WRFV3/test/em_real/namelist.input



else

if  [ $date -eq 08 ]

then 

 # wget -P /$pwd/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month'09'/*.grb2#

sed -i '4 c\
start_date ='"'$year-$month-$date"_"06:00:00'"','"'$year-$month-$date"_"06:00:00'"','"'$year-$month-$date"_"06:00:00'"''  /$pwd/WPS/namelist.wps


sed -i '5 c\
end_date ='"'$year-$month-09"_"06:00:00'"','"'$year-$month-09"_"06:00:00'"','"'$year-$month-09"_"06:00:00'"''  /$pwd/WPS/namelist.wps


sed -i '8 c\
 start_day\t\t\t     = '$date,$date,$date,'' /$pwd/WRFV3/test/em_real/namelist.input


sed -i '14 c\
 end_day\t\t\t     = ''09','09','09'',' /$pwd/WRFV3/test/em_real/namelist.input



else

if [ $date -gt 10 ]

then 

# wget -P /$pwd/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month$((date+1))/*.grb2

sed -i '4 c\
start_date ='"'$year-$month-$date"_"06:00:00'"','"'$year-$month-$date"_"06:00:00'"','"'$year-$month-$date"_"06:00:00'"''  /$pwd/WPS/namelist.wps

sed -i '5 c\
end_date = '"'$year-$month-$((date+1))"_"06:00:00'"','"'$year-$month-$((date+1))"_"06:00:00'"','"'$year-$month-$((date+1))"_"06:00:00'"'' /$pwd/WPS/namelist.wps


sed -i '8 c\
 start_day\t\t\t     = '$date,$date,$date,'' /$pwd/WRFV3/test/em_real/namelist.input

sed -i '14 c\
 end_day\t\t\t     = '$((date+1))','$((date+1))','$((date+1))'', /$pwd/WRFV3/test/em_real/namelist.input



else

#  wget -P /$pwd/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month'0'$((date+1))/*.grb2

sed -i '4 c\
start_date ='"'$year-$month-$date"_"06:00:00'"','"'$year-$month-$date"_"06:00:00'"','"'$year-$month-$date"_"06:00:00'"''  /$pwd/WPS/namelist.wps


sed -i '5 c\
end_date = '"'$year-$month-0$((date+1))"_"06:00:00'"','"'$year-$month-0$((date+1))"_"06:00:00'"','"'$year-$month-0$((date+1))"_"06:00:00'"'' /$pwd/WPS/namelist.wps



sed -i '8 c\
 start_day\t\t\t     = '$date,$date,$date,'' /$pwd/WRFV3/test/em_real/namelist.input

sed -i '14 c\
 end_day\t\t\t     = ''0'$((date+1)),'0'$((date+1)),'0'$((date+1)),'' /$pwd/WRFV3/test/em_real/namelist.input

  
 fi
 fi
fi




cd /$pwd/WPS/


rm met_em.d0* GRIBFILE.A* geo_em.d0* FILE\:2017*

#run the geogrid
./geogrid.exe

#run the link grib for initial condition downloaded from NCEP

./link_grib.csh ../gfs-anl/

#Run the ungrib files

./ungrib.exe

#run the metgrid for meterologica

./metgrid.exe



#WRF folder run
cd ..
cd WRFV3/test/em_real
ln -sf ../../../WPS/met_em.d0* .

if [ -e wrfout_d0* ]
then 
mkdir output_$date
mv wrfout_* output_$date
else
echo "ready for wrf run"
fi

./real.exe

./wrf.exe






#sed -i '4 c\
#start_date ='"'$year-$month-$date"_"06:00:00'"','"'$year-$month-$date"_"06:00:00'"','"'$year-$month-$date"_"06:00:00'"''  ~/$pwd/WRFV3/test/em_real/namelist.input

#sed -i '5 c\
#end_date = '"'$year-$month-$((date+1))"_"06:00:00'"','"'$year-$month-$((date+1))"_"06:00:00'"','"'$year-$month-$((date+1))"_"06:00:00'"'' ~/$pwd/WRFV3/test/em_real/namelist.input





#echo wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month$date/*.grb2

#echo wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month$((date+1))/*.grb2
#echo wget -P /home/smahmud/WRF/gfs-anl/  ftp://nomads.ncdc.noaa.gov/GFS/analysis_only/$year$month/$year$month$((date+1))/*.grb2

