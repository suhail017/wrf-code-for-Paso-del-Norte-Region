 filename = "wrfout_d03_2017-06-02_06_00_00"
  fin      = addfile(filename+".nc","r")


res=True
loc  = wrf_user_ll_to_ij(fin, -106.45, 31.76, res)
print(loc)

H1 = wrf_user_getvar(fin,"tc",-1)
H2 = wrf_user_getvar(fin,"rh",-1)
H3 = wrf_user_getvar(fin,"ua",-1)
H4 = wrf_user_getvar(fin,"va",-1)
H5 = wrf_user_getvar(fin,"PBLH",-1)

p1 = H1(:,1,loc(0),loc(1))
p2 = H2(:,1,loc(0),loc(1))
p3 = H3(:,1,loc(0),loc(1))
p4 = H4(:,1,loc(0),loc(1))
p5 = H5(:,loc(0),loc(1))
wspd = sqrt(p3^2+p4^2)  
print(p1)
print(p2)
print(p3)
print(p5)   


 ;filename = "example1b.csv"
 ; system("rm -rf " + filename)
  ;write_table(filename,"w",[/p1,p2,wspd/],"%2i,%2i,%2i")

  ;print("`==================== " + filename + " ====================")
  ;system("cat " + filename)


  tmp=(sprintf("%5.2f",p1)+ \
                "   "+sprintf("%5.2f",p2)+ \
		"   "+sprintf("%5.2f",wspd)+ \
		"   "+sprintf("%5.2f",p5))
tmp(0)= "Temp(C)  RH(%)  Wspd(m/s  PBLH)"

asciiwrite("fnam1.txt",tmp)
