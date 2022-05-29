%%rotina criada por Maria Isabel
%%%Pré-tratamento, tiagem dos perfis a serem utilizados
%%vórtice T2
cd /home/mariaisabel/Documentos/Dados_mestrado/cruzamento/Dados_artigo/t2/
load cruzamento_t6.mat
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/m_map/')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/m_map/private/')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/seawater/')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/mexcdf/')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/mexcdf/snctools/')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/mexcdf/mexnc/')


load dados_semrepeticao.mat
%retirando perfis vazios
 
 dados_sal_argo=dados_sal_argo';
 dados_temp_argo=dados_temp_argo';
 dados_pres_argo=dados_pres_argo';

%simplificando os nomes das variaveis
temp=dados_temp_argo;
sal=dados_sal_argo;
pres=dados_pres_argo;
clear dados_pres_argo dados_sal_argo dados_temp_argo

%triagem dos dados de temp e sal 
%Baseado em Chaigneau, 2011
%Thus, for our analysis we only considered profiles for which (1) the shallowest data are located between the surface and 10 m depth 
%and the deepest acquisition is below 1000 m; (2) the depth difference between two consecutive data does not exceed a given limit (Δzlim) which depends on the considered depth 
%(Δzlim = 25 m for the 0–100 m layer; Δzlim = 50 m for the 100–300 m layer; and Δzlim = 100 m for the 300–1000 m layer); and (3) the number of data levels in the 0–1000 m layer is higher than 30.
%Para z(1) maior que 10
ind_esp2=find(pres(1,:)>10);
temp1(:,ind_esp2)=[];
sal1(:,ind_esp2)=[];
pres1(:,ind_esp2)=[];
dados_dia_argo(ind_esp2)=[];
dados_station_argo(ind_esp2,:)=[];
dados_lat_argo(ind_esp2)=[];
dados_lon_argo(ind_esp2)=[];
dados_amp_emason(ind_esp2)=[];
dados_data_emason(ind_esp2)=[];
dados_lat_emason(ind_esp2)=[];
dados_lon_emason(ind_esp2)=[];
dados_diam_emason(ind_esp2)=[];
z(:,ind_esp2)=[];



%transformando pres em z
 for i=1:length(dados_lon_argo)
    pres_coluna=pres(:,i);
    z_coluna=sw_dpth(pres_coluna,dados_lat_argo(i));
    z(:,i)=z_coluna;
 end
 clear z_coluna pres_coluna i
 %para procurar diferencas maiores que 25m nos primeiros 100 m

for i=1:length(dados_dia_argo)
    z_coluna=z(:,i);
    id_100=find(z_coluna>=-100);
    z_100=z_coluna(id_100);
    diferenca=diff(z_100);
    dif_total(1:length(diferenca),i)=diferenca;
end
ind_esp3=find(dif_total<-25);
clear z_100 z_coluna diferenca id_100 i

%%para procurar diferencas maiores que 50m entre 100e 300m
for i=1:length(dados_dia_argo)
    z_coluna=z(:,i);
    id_100=find(z_coluna<-100 & z_coluna>=-300);
    z_100=z_coluna(id_100);
    diferenca=diff(z_100);
    dif_total2(1:length(diferenca),i)=diferenca;
end
ind_esp4=find(dif_total2<-50); 
clear id_100 i diferenca dif_total2 z_100 z_coluna
%%para procurar diferencas maiores que 100m entre 300e 1000m
for i=1:length(dados_dia_argo)
    z_coluna=z(:,i);
    id_100=find(z_coluna<-300 & z_coluna>=-1000);
    z_100=z_coluna(id_100);
    diferenca=diff(z_100);
    dif_total3(1:length(diferenca),i)=diferenca;
end
ind_esp5=find(dif_total3<-100);
% procurando valores maximos de prof
for t=1:length(dados_lon_argo)
    z_coluna=z(:,t);
    teste=isnan(z_coluna);
    prof_max(:,t)=max(z_coluna);
end
% eliminando perfis mais rasos que 1500m
ind_r=find(prof_max<1490);
temp(:,ind_r)=[];
sal(:,ind_r)=[];
pres(:,ind_r)=[];
dados_dia_argo(ind_r)=[];
dados_station_argo(ind_r,:)=[];
dados_lat_argo(ind_r)=[];
dados_lon_argo(ind_r)=[];
z(:,ind_r)=[];
dados_amp_emason(ind_r)=[];
dados_data_emason(ind_r)=[];
dados_lat_emason(ind_r)=[];
dados_lon_emason(ind_r)=[];
dados_diam_emason(ind_r)=[];
%retirando perfis que nao tem dados nos primeiros 10 metros
ind_esp6=find(isnan(sal(2,:)));
temp(:,ind_esp6)=[];
sal(:,ind_esp6)=[];
pres(:,ind_esp6)=[];
dados_dia_argo(ind_esp6)=[];
dados_station_argo(ind_esp6,:)=[];
dados_lat_argo(ind_esp6)=[];
dados_lon_argo(ind_esp6)=[];
z(:,ind_esp6)=[];
dados_amp_emason(ind_esp6)=[];
dados_data_emason(ind_esp6)=[];
dados_lat_emason(ind_esp6)=[];
dados_lon_emason(ind_esp6)=[];
dados_diam_emason(ind_esp6)=[];
teste=find(prof>1500);
sal1(teste)=nan;
temp1(teste)=nan;
pres1(teste)=nan;
z(teste)=nan;
prof(teste)=nan;