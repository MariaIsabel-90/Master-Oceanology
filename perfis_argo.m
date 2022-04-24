%rotina para cruzmento dos dados
%criada em 08/05/18
lat=nc_varget('sa_argo.nc','latitude');
lon=nc_varget('sa_argo.nc','longitude');
time=nc_varget('sa_argo.nc','date_time');
temp=nc_varget('sa_argo.nc','var2');
sal=nc_varget('sa_argo.nc','var3');
pressure=nc_varget('sa_argo.nc','var1');
station=nc_varget('sa_argo.nc','metavar1');
%convertendo os dias decimais em datenum e em dias gregorianos
teste=datenum(1999,1,1);
dia_teste=time+teste;
[Y,M,D,H]=datevec(dia_teste);
dia_julian=julian(Y,M,D,H);
ind_periodo=find(dia_julian >=2454467 & dia_julian <=2456658.95833333);   
data_cruzamento=dia_julian(ind_periodo);
temp_cruzamento=temp(ind_periodo,:);
sal_cruzamento=sal(ind_periodo,:);
press_cruzamento=pressure(ind_periodo,:);
lat_cruzamento=lat(ind_periodo);
lon_cruzamento=lon(ind_periodo);
station_cruzamento=station(ind_periodo,:);
