%rotina para cruzmento, identificacao e separacao dos perfis argo
%Feita em 09/05/18
%incluindo pacote seawater
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/m_map/')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/m_map/private/')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/seawater/')
load argo_todosperfis.mat
%%%encontrar lat/lon iguais *HELLBOUND*)
    k1=1;
    i=1;
    l=1;
   while k1<198                                              % selecionar em latitudes iguais
        while i<length(lon_cruzamento)+1
            dist_perfil=sw_dist([lat_cruzamento(i,1) lat_traj21(k1,1)],[lon_cruzamento(i,1) lon_traj21(k1,1)],'km');
             %if lon_cruzamento(i,1)>=(long_testeargo(k1,1)-2.5) &&lon_cruzamento(i,1)<=(long_testeargo(k1,1)+2.5) && lat_cruzamento(i,1)>=(lat_testeargo(k1,1)-2.5) && lat_cruzamento(i,1)<=(lat_testeargo(k1,1)+2.5);
             if dist_perfil<=2*raio_traj21(k1,1)
                dist_obs(l,1)=dist_perfil; 
                a(l,1)=k1;  %indice de latitude da trajetoria do vortice
                b(l,1)=i; %indice de latitude da trajetoria da boia argo
                l=l+1;
            end
            
            i=i+1;
        end
        i=1;
        k1=k1+1;
     end
index=[a b];
         %plat_num=str2num(platform_number(1,:));
         e=index(:,1);
         f=index(:,2);
         m=find(((data_cruzamento(f))<=(dia_traj21(e)+1))&((data_cruzamento(f))>=(dia_traj21(e)-1)));
         lu=e(m);
         na=f(m);
         iguais_dia=m;
     %os dias   %separando os vetores com os dados
   dados_temp_argo=temp_cruzamento(na,:);
   dados_sal_argo=sal_cruzamento(na,:);
   dados_pres_argo=press_cruzamento(na,:);
   dados_dia_argo=data_cruzamento(na);
   dados_station_argo=station_cruzamento(na,:);
   dados_lat_argo=lat_cruzamento(na);
   dados_lon_argo=lon_cruzamento(na);
   %dados dos vortices
   dados_lat_emason=lat_traj20(lu);
   dados_lon_emason=lon_traj20(lu);
   dados_diam_emason=2*raio_traj20(lu);
   dados_dia_emason=dia_traj20(lu);
   dados_data_emason=dia_traj20(lu);
   dados_amp_emason=amplitude_traj20(lu);
 %salvando os dados
 save cruzamento_t20.mat dados_amp_emason dados_data_emason dados_dia_argo dados_diam_emason dados_lat_argo dados_lat_emason dados_lon_argo dados_lon_emason dados_sal_argo dados_temp_argo dados_station_argo dados_pres_argo
 save indices_t21.mat a b index e f m na lu 
 %%
 %mapa entre as trajetorias e o vortice
figure(3)%abrindo uma nova figura
%criando primeiro a figura com a c
m_proj( 'mercator','lon<gitude>', [-40 30],'lat<itude>',[-50 -10]) %
m_coast('patch',[.7 .7 .7],'edgecolor','b'); 
m_grid; hold on
m_track(lon_traj11,lat_traj11,'linew',2)
hold on
m_line(dados_lon_argo,dados_lat_argo,'marker','*','color','blue','linest','none','markersize',3)
m_grid('box','fancy','tickdir','in');
m_etopo2
xlabel('Longitude','interpreter','latex','FontSize',16)
ylabel('Latitude','interpreter','latex','FontSize',16)
saveas(gcf,'cruzamento_21','fig')
%%
%retirando perfis repetidos
 for i=1:62
        lon1=dados_lon_argo(i);
        lon2=dados_lon_argo(i+1);
        if lon2==lon1;
            ind_test(i,:)=1;
        else
            ind_test(i,:)=0;
        end
        
 end
ind_man=find(ind_test==1);
dados_lon_argo(ind_man)=[];
dados_lat_argo(ind_man)=[];
dados_dia_argo(ind_man)=[];
dados_pres_argo(ind_man,:)=[];
dados_sal_argo(ind_man,:)=[];
dados_temp_argo(ind_man,:)=[];
dados_station_argo(ind_man,:)=[];
%dos vortices
   dados_lat_emason(ind_man)=[];
   dados_lon_emason(ind_man)=[];
   dados_diam_emason(ind_man)=[];
   dados_dia_emason(ind_man)=[];
   dados_data_emason1(ind_man)=[];
   dados_amp_emason(ind_man)=[];

save perfis_semrepeticao.mat dados_dia_argo dados_lat_argo dados_lon_argo dados_sal_argo dados_temp_argo dados_station_argo dados_pres_argo ind_man ind_test
%%
%calculando a distancia entre os perfis e o vortice
%em y
for i=1:79
dist_perfil=m_lldist([dados_lat_argo(i,:) dados_lat_emason(i,:)],[dados_lon_argo(i,:), dados_lon_argo(i,:)],'km');
dist_lat1(i,:)=dist_perfil;
%fase_todos(i,:)=ph;
end
%em x
for i=1:79
dist_perfil=m_lldist([dados_lat_argo(i,:) dados_lat_argo(i,:)],[dados_lon_argo(i,:), dados_lon_emason(i,:)],'km');
dist_lon1(i,:)=dist_perfil;
%fase_todos(i,:)=ph;
end
%em graus de latitude
for j=1:34
int_lat=dados_lat_argo(j,:) - dados_lat_emason(j,:);
delta_lat(j,:)=int_lat;
end
for k=1:34
int_lon=dados_lon_argo(k,:) - dados_lon_emason(k,:);
delta_lon(k,:)=int_lon;
end
%calculando distancia relativa ao centro do vortice
%em x
for r=1:79

    if dados_lon_argo(r)>dados_lon_emason(r)
        %dist_ef(r,1)=dist_obs(r)*nanmean(diam_mason)/dados_diam_emason(r);
        dist_ef(r,1)=dist_lon1(r)./raio_emason(r);
    else  
        %dist_ef(r,1)=dist_obs(r)*nanmean(diam_mason)/dados_diam_emason(r)*-1;
        dist_ef(r,1)=dist_lon1(r)./raio_emason(r)*-1;

    end
end
%em y
for r=1:79

    if dados_lat_argo(r)>dados_lat_emason(r)
        %dist_ef(r,1)=dist_obs(r)*nanmean(diam_mason)/dados_diam_emason(r);
        dist_ef2(r,1)=dist_lat1(r)./raio_emason(r);
    else  
        %dist_ef(r,1)=dist_obs(r)*nanmean(diam_mason)/dados_diam_emason(r)*-1;
        dist_ef2(r,1)=dist_lat1(r)./raio_emason(r)*-1;

    end
end

%testando o scatterplot
figure (2)
scatter(0,0,100,'k','*')
hold on; circle(0,0,2) 
%hold on; circle(0,0,1)
hold on; scatter(dist_ef,dist_ef2,'b','*')
%ordem de cores: verde, azul, vermelho,preto, amarelo, magenta, ciano
xlabel('Delta x','interpreter','latex','FontSize',16)
ylabel('Delta y','interpreter','latex','FontSize',16)
title('Distância normalizada de perfis Argo em km- Vórtice t12', 'interpreter','latex','FontSize',18)
saveas(gcf,'scatter_normalizado_t2','png')
%lapso temporal dos perfis argo
%em horas
for j=1:79
int_hora=greg_argo(j,:) - greg_vortice(j,:);
delta_hora(j,:)=int_hora;
end
%transformando os dados pra apenas horas