%rotina para reconstrucao da estrutura vertical do vortice
clear all
cd /DADOS/Altimetria/AVISO/id_vorticesTA6/
load teste_cruzamento_traj9.mat
addpath('/DADOS/toolbox/gsw/')
addpath('/DADOS/toolbox/m_map/')
addpath('/DADOS/toolbox/timeplt')
addpath('/DADOS/toolbox/saga')
load teste_raio_mason_t6_9.mat
diametro_testeargo=raio_testeargo*2;
dados_diam_emason=diametro_testeargo(lu);
for f=1:58
figure(3)%abrindo uma nova figura
%criando primeiro a figura com a c
m_proj( 'mercator','lon<gitude>', [-40 30],'lat<itude>',[-50 -10]) %
m_coast('patch',[.7 .7 .7],'edgecolor','b'); 
m_grid; hold on
m_etopo2('contourf')
m_track(long_testeargo,lat_testeargo,'linew',5)
hold on
m_track(dados_lon_argo(f),dados_lat_argo(f),'color','red','lines','*')
end
%normalizando os dados em funcao da distancia do centro do vortice para
%cada perfil
dados_temp_argo=dados_temp_argo';
dados_sal_argo=dados_sal_argo';
for i=1:58
    sal_ef=(dados_sal_argo(:,1)*dados_amp_padronizada);
    %temp_ef(:,i)=(dados_temp_argo(:,i)*dados_amp_emason(i))/nanmean(dados_amp_emason);
end
%distancia efetiva
for t=1:58
dist_perfil=sw_dist([dados_lat_argo(t,1) dados_lat_emason(t,1)],[dados_lon_argo(t,1) dados_lon_emason(t,1)],'km');
dist_obs(:,t)=dist_perfil;
end
for r=1:58
    dist_ef(r,:)=dist_obs(r)*dados_diam_emason(r)/nanmean(dados_diam_emason);
end
dist_ef=dist_ef(:,1);

%calculando uma secao vertical dos valores de temperatura brutos
%tranformando a pressao em profundidade
%para transformar pressao em profundidade
z=sw_dpth(dados_pres_argo,dados_lat_argo);
z=z';
%interpolando os dados de profundidade para intervalos regulares
for i=1:58
    dados=z_teste(:,i);
    teste=isnan(dados);
    ind_nan=find(teste==1);
    dados(teste)=[];
    X=linspace(0,2000,length(dados));
    Xq=1:10:2000;
    z_interp2(:,i)=interp1(X,dados,Xq);
end
%para temperatura
temp_teste=dados_temp_argo(1:112,:);
for i=1:58
    dados=temp_teste(:,i);
    teste=isnan(dados);
    ind_nan=find(teste==1);
    dados(teste)=[];
    X=linspace(0,2000,length(dados));
    Xq=1:10:2000;
    temp_interp(:,i)=interp1(X,dados,Xq);
end

%plotando os resultados
%criando uma variavel latitude 
[dist2d,prof2d]=meshgrid(dist_ef,z_interp2(:,1));
dados_temp_argo=dados_temp_argo';
z_linha=z(1:112,:);
temp_linha=dados_temp_argo(1:112,:);
dist_linha=dist2d(1:112,:);
figure (1)
contourf(dist2d,z_interp2,temp_interp)% contornado a variavel
set(gca,'ydir','reverse')
%%
%calculando as anomalias utilizando o banco de dados NODC da Noaa
clear all
cd /home/aluno/Downloads/climatologia
[teste_t,indice]=sort(dist_ef);