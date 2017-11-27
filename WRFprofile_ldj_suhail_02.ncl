load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

undef ("General_Settings")
function General_Settings(LeftString:string,CenterString:string,RightString:string)
begin
   res                        = True
   res@gsnPaperOrientation    = "portrait"   ;"landscape" ;"portrait"
   res@gsnMaximize            = True          ; Maximize plot in frame.
   res@gsnDraw                = False
   res@gsnFrame               = False         ; don't advance frame yet for overlay
   ;res@vpXF                   = 0.15          ; x location
   ;res@vpYF                   = 0.90          ; y location
   ;res@vpWidthF               = 0.7           ; width
   ;res@vpHeightF              = 0.40          ; height
   res@gsnLeftString          = LeftString
   res@gsnRightString         = RightString
   res@gsnCenterString        = CenterString
   res@tfDoNDCOverlay         = True          ; True for 'native' grid
   return(res)
end

begin

   in     = addfile("wrfout_d03.nc","r")
;   in = addfile("wrfout_d01_2017-10-25_12:00:00"+".nc","r")
   times = wrf_user_list_times(in)            ; get times in the file
   ntimes = dimsizes(times)            ; number of times in the file
;   print(times)
   lat = 31.7     ;28.0           ; Latitude of the point of interest
   lon = -106.6   ;-90.0          ; Longitude of the point of interest
   res = True
   res@returnInt = True        ;False:return real, True:return interger
   point = wrf_user_ll_to_ij(in,lon,lat,res)       ;
   delete(res)

   point = point-1          ; To convert to NCL subscripts
   ii=point(0)
   jj=point(1)

   level=(/1000.0,1500.0,2000.0,3000.0,4000.0,5000.0,6000.0,10000.0,15000.0,20000.0,25000.0/)  ; unit of m
   num_lev=dimsizes(level)
   print("num_lev="+num_lev)
   lev_str=new(num_lev,string,"")
   do k=0,num_lev-1
      lev_str(k)=lev_str(k) + flt2string(level(k))+"m "
   end do
   print(lev_str)
   tmp_str=new(ntimes*(num_lev+1)+1,string)
   tmp_str(0)="Height(m) Temp(C)  RH(%)  Pressure (pa) Wspd(m/s) )"

   count=1
   works = "pdf"
   output= "profile"
   wks = gsn_open_wks(works, output)

   do it = 0,ntimes-1                  ;Loop for the time: it= starting time
      print("Working on time " + it )

      uuuu = wrf_user_getvar(in,"ua",it)   ; mass u
      vvvv = wrf_user_getvar(in,"va",it)   ; mass v
      h = wrf_user_getvar(in,"z",it)       ; unit of m
      tc = wrf_user_getvar(in,"tc",it)     ; unit of C
      rh= wrf_user_getvar(in,"rh",it)     ; unit of %
      p=wrf_user_getvar(in,"p",it)       ;unit of pa
      wspd = sqrt(uuuu^2 + vvvv^2)
; vertical interpolation
      u_intp=wrf_user_intrp3d(uuuu,h,"h",level,0.,False)
      v_intp=wrf_user_intrp3d(vvvv,h,"h",level,0.,False)
      tc_intp=wrf_user_intrp3d(tc,h,"h",level,0.,False)
      rh_intp=wrf_user_intrp3d(rh,h,"h",level,0.,False)
      p_intp=wrf_user_intrp3d(p,h,"h",level,0.,False)
      wspd_intp=wrf_user_intrp3d(wspd,h,"h",level,0.,False)
;      print(tc_intp(:,jj,ii))
;     print(h(:,jj,ii)+" "+uuuu(:,jj,ii)+" "+vvvv(:,jj,ii)+" "+wspd(:,jj,ii))

      res=General_Settings(" ",times(it)+" UTC"," ")
      res@xyMarkLineMode       = "MarkLines"  ; Lines, MarkLines, Markers
      res@xyMarkers            = 16
      res@xyMarkerSizes        = 0.005
;;
      res@tiXAxisString = "Temperature (C)"
      res@tiYAxisString = "Height (m)"
      plot_xy = gsn_csm_xy (wks,tc_intp(:,jj,ii),level,res)
      draw(plot_xy)
      frame(wks)
;;
      res@tiXAxisString = "Relative Humidity (%)"
      res@tiYAxisString = "Height (m)"
      plot_xy = gsn_csm_xy (wks,rh_intp(:,jj,ii),level,res)
      draw(plot_xy)
      frame(wks)
;;
      res@tiXAxisString = "wind speed (m/s)"
      res@tiYAxisString = "Height (m)"
      plot_xy = gsn_csm_xy (wks,wspd_intp(:,jj,ii),level,res)
      draw(plot_xy)
      frame(wks)


;;


res@tiXAxisString = "pressure"
      res@tiYAxisString = "Height (m)"
      plot_xy = gsn_csm_xy (wks,p_intp(:,jj,ii),level,res)
      draw(plot_xy)
      frame(wks)
;;;;
      tmp_str(count)=times(it)
      count = count + 1
      do k=0,num_lev-1
         tmp=sprintf("%8.0f",tc_intp(k,jj,ii))+ \
                " "+sprintf("%8.0f",rh_intp(k,jj,ii))+ \
		" "+sprintf("%8.0f",p_intp(k,jj,ii))+ \
                " "+sprintf("%8.0f",wspd_intp(k,jj,ii))
         tmp_str(count)=lev_str(k)+" "+tmp
         count = count + 1
      end do
   end do
   asciiwrite ("profile_out.dat", tmp_str)
   
end
