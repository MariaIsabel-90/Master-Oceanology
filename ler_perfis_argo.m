%Rotina para ler dados da boias ARGO
clear all
%para os dados da regiao de retroflexao
cd /DADOS/ARGO/Retroflexao %diretorios onde ficam os dados
%adicionando as pastas com as funcoes que vao ser usadas
addpath('/DADOS/toolbox_matlab/argo_profile_matlab_reader/')
addpath('/DADOS/toolbox_matlab/seawater/')
addpath('/DADOS/toolbox_matlab/netcdf/')
addpath('/DADOS/toolbox_matlab/ncutility/')
addpath('/DADOS/toolbox_matlab/snctools/')
addpath('/DADOS/toolbox_matlab/mexnc/')
addpath('/DADOS/toolbox_matlab/tsplot/')
addpath('/DADOS/toolbox_matlab/timeplt/')

%modificado da rotida do catarina
%carregando as variaveis gerais
perfil1=netcdf('argo-profiles-7900420.nc','read'); %para ler os dados
latitude=perfil1{'LATITUDE'}(:);
longitude=perfil1{'LONGITUDE'}(:);
reference_date_time=perfil1{'REFERENCE_DATE_TIME'}(:);
dayref=julian(sscanf(reference_date_time(1:4),'%f'),...
	    sscanf(reference_date_time(5:6),'%f'),sscanf(reference_date_time(7:8),'%f'),0);    
dia_julian=perfil1{'JULD'}(:)+dayref; %correcao para transformar os dias julianos em data do matlab
%para transformar dia juliano em dia de matlab
teste=gregorian(dia_julian);
%teste para um dia
%dia_matlab=datenum(teste(1,1),teste(1,2),teste(1,3),teste(1,4),teste(1,5),teste(1,6));
%para todos os dias
i=0;
for r=1:77
i=i+1;
dia_matlab(:,i)=datenum(teste(r,1),teste(r,2),teste(r,3),teste(r,4),teste(r,5),teste(r,6));
end
direction  = perfil1{'DIRECTION'}(:);
%para ler os dados de pressao, temperatura e salinidade
%temperatura
temp=perfil1{'TEMP'}(:);%variavel temperatura
temp_qc=perfil1{'TEMP_QC'}(:);%temperatura que teve a qualidade avaliada
temp_fillvalue = perfil1{'TEMP'}.FillValue_(:);%identificando o valor usado para dados espureos
temp_units=perfil1{'TEMP'}.units(:);
ind_esp=find(temp==temp_fillvalue);
temp(ind_esp)=nan;
%Selection of measurements with QC=1 or QC=2 or QC=5
inok =find(double(temp_qc)~= double('1') &...
	   double(temp_qc)~= double('2') & ...
	   double(temp_qc)~= double('5'));
if ~isempty(inok)
  temperature(inok)=NaN;
end
clear temp_qc temp_fillvalue temp_units ind_esp inok direction reference_date_time temperature dayref

%para salinidade
sal=perfil1{'PSAL'}(:);%variavel salinidade
sal_qc=perfil1{'PSAL_QC'}(:);%salinidade que teve a qualidade avaliada
sal_fillvalue = perfil1{'PSAL'}.FillValue_(:);%identificando o valor usado para dados espureos
sal_units=perfil1{'PSAL'}.units(:);
ind_sesp=find(sal==sal_fillvalue);
sal(ind_sesp)=nan;
%Selection of measurements with QC=1 or QC=2 or QC=5
inok =find(double(sal_qc)~= double('1') &...
	   double(sal_qc)~= double('2') & ...
	   double(sal_qc)~= double('5'));
if ~isempty(inok)
  sal(inok)=NaN;
end
clear sal_qc sal_fillvalue sal_units ind_sesp inok salitnity
%para pressao
%PRESSURE
pressure = perfil1{'PRES'}(:);
pres_fillvalue = perfil1{'PRES'}.FillValue_(:);
pres_units=perfil1{'PRES'}.units(:);
inok = find(pressure==pres_fillvalue);
if ~isempty(inok)
  pressure(inok)=NaN;
end
clear pres_fillvalue pres_units ind_sesp inok 
clear perfil1
%para criar os perfis T/S
for i=1:10
figure (i)
subplot(1,2,1)
if ~isempty(temp)
  plot(temp(i,:),pressure(i,:),'b')
  xlabel('temperature (deg.C)','Fontsize',8)
  ylabel('pressure (dcb)','Fontsize',8)
  grid on
  
end
subplot(1,2,2)
if ~isempty(sal)
  plot(sal(i,:),pressure(i,:),'g')
  xlabel('salinity (psu)','Fontsize',8)
  ylabel('pressure (dcb)','Fontsize',8)
  grid on
end
end
set(gcf,'color',[1 1 1])
%para criar diagramas T/S
%cada estacao
sal=sal';
temp=temp';
pressure=pressure';
for n= 1:3
figure 
tsdiagram(sal(:,n),temp(:,n),pressure(:,n))
end
%média pra boia
mean_temp=nanmean(temp);
mean_sal=nanmean(sal);
mean_pressure=nanmean(pressure);
mean_temp=mean_temp';
mean_sal=mean_sal';
mean_pressure=mean_pressure';

figure (23)
tsdiagram(mean_sal,mean_temp,mean_pressure)
%para desenhar a trajetora
figure (2)
plot(longitude, latitude)
hold on; plot(longitude(7), latitude (7),'s')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%para identificar flutuadores Argo que cruzam o caminho de vortices%%
%para ler os dados
cd /DADOS/ARGO/Retroflexao %diretorios onde ficam os dados
%adicionando as pastas com as funcoes que vao ser usadas
addpath('/DADOS/toolbox_matlab/argo_profile_matlab_reader/')
addpath('/DADOS/toolbox_matlab/seawater/')
addpath('/DADOS/toolbox_matlab/netcdf/')
addpath('/DADOS/toolbox_matlab/ncutility/')
addpath('/DADOS/toolbox_matlab/snctools/')
addpath('/DADOS/toolbox_matlab/mexnc/')
addpath('/DADOS/toolbox_matlab/tsplot/')
%escolhendo os flutuadores com dados validos de T e S

perfil1=netcdf('1900487_prof.nc','read'); %para ler os dados
sal=perfil1{'PSAL'}(:);%variavel salinidade
temp=perfil1{'TEMP'}(:);%perfil1=netcdf('argo-profiles-1900052.nc','read'); %para ler os dados
latitude=perfil1{'LATITUDE'}(:);
longitude=perfil1{'LONGITUDE'}(:);
%reference_date_time=perfil1{'REFERENCE_DATE_TIME'}(:);
reference_date_time=nc_varget('argo-profiles-7900420.nc','REFERENCE_DATE_TIME');
dayref=datenum(sscanf(reference_date_time(1:4),'%f'),...
	    sscanf(reference_date_time(5:6),'%f'),sscanf(reference_date_time(7:8),'%f'),0,0,0);
dia_julian=nc_varget('argo-profiles-7900420.nc','JULD')+dayref; %correcao para transformar os dias julianos em data do matlab
platform_number  = f_cdf{'PLATFORM_NUMBER'}(:);
if isempty(sal)==0 && isemty(temp)==0
save perfil(i).mat sal temp longitude latitude dia_julian platform_number
end
