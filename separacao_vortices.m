%Rotina para identificar e separar as trajetorias utilizadas no artigo
%Autora: Maria Isabel
%Data de criacao: 07/05/18
%Escolhendo uma trajetoria
cd /home/mariaisabel/Documentos/Dados_mestrado/cruzamento
%incluindo os toolboxes necessarios
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/mexcdf/mexnc')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/mexcdf/')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/mexcdf/snctools/')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/m_map/')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/m_map/private/')
addpath('/home/mariaisabel/Documentos/MATLAB/toolbox/timeplt')
%para carregar as variaveis de netcdf
track=nc_varget('id_vorticeseddy_tracks_SLA_AVISO_anticyclonic.nc','track');
track_number=nc_varget('id_vorticeseddy_tracks_SLA_AVISO_anticyclonic.nc','n');
lat=nc_varget('id_vorticeseddy_tracks_SLA_AVISO_anticyclonic.nc','lat');
lon=nc_varget('id_vorticeseddy_tracks_SLA_AVISO_anticyclonic.nc','lon');
dia_obs=nc_varget('id_vorticeseddy_tracks_SLA_AVISO_anticyclonic.nc','j1');
amplitude=nc_varget('id_vorticeseddy_tracks_SLA_AVISO_anticyclonic.nc','A');
raio=nc_varget('id_vorticeseddy_tracks_SLA_AVISO_anticyclonic.nc','radius_e');
%encontrando as trajetorias
%para selecionar uma so trajetoria q pertença a um vortice das Agulhas
for r= 1:track(end)
    ind_traj=find(track==r);
    if lon(ind_traj(1))>=0 && lon(ind_traj(1))<=20 %regiao de formacao dos vortices  
       traj_retro(:,r)=1;
    else
        traj_retro(:,r)=0;
    end
end
ID_cross=find(traj_retro==1);
%para identificar trajetorias de duracao maior ou igual a 180 dias
for i=1:length(ID_cross)
    ind_trajretro=find(track==ID_cross(i));
    comp_trajetoria(:,i)=length(ind_trajretro);
    if comp_trajetoria(i)> 180
        traj_teste(:,i)=1;
    else
        traj_teste(:,i)=0;
    end
end
ID_agulhas=find(traj_teste==1);
%separando e salvando as trajetorias
indtraj4=find(track==ID_cross(ID_agulhas(4)));
lon_traj4=long(indtraj4);
lat_traj4=latitude(indtraj4);
raio_traj4=raio(indtraj4);
amplitude_traj4=amplitude(indtraj4);
dia_traj4=dia_observacao(indtraj4);
%save traj22.mat lon_traj22 lat_traj22 raio_traj22 amplitude_traj22 dia_traj22
clear lon_traj7 lat_traj7 raio_traj7 amplitude_traj7 dia_traj7


%plotando todas as trajetorias
