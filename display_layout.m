function [  ] = display_layout( handles )
% Display Layout in a new window and plot components

[~,DATA,A_space,S_space,SX_azimuth,z_positive,~] = get_survey_GUI_var(handles);
Xstn_box=str2double(get(handles.Xstn_box,'String'));
Ystn_box=str2double(get(handles.Ystn_box,'String'));

global tequila_status

    % if in UTM mode get azimuth from handles.
     for i=1:size(DATA,1)
       if strcmp(DATA{i,1}(1),'H')
           if ~isempty(handles.Ant)
                DATA{i,6}=handles.Ant.num{i};
                DATA{i,7}=handles.Ant.azm{i}; 
           else
                DATA{i,6}=[];
                DATA{i,7}=[];  
           end
       end
     end
    % CHECK IF LAYOUT IS COMPLETE
    for ch=1:size(DATA,1)
         if strcmp(DATA{ch,1},'Off'); continue;end
        for col=2:7
            if isempty(DATA{ch,col}) || isnan(DATA{ch,col}) 
                
                if tequila_status==false
                       beep
                       set(handles.error_msg,'Visible','on','String',handles.language.commit_msg5)
                       set(handles.survey_panel,'BackgroundColor','red')
                       pause(0.1)
                       set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
                       pause(0.1)
                       set(handles.survey_panel,'BackgroundColor','red')
                       pause(0.1)
                       set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
                end
                       return; 
            end
        end
    end  

     
RowName=get(handles.geometry_table,'RowName');

ZenACQ_vars.main=handles.main;
ZenACQ_vars.setting=handles.setting;
ZenACQ_vars.language=handles.language;
ZenACQ_vars.DATA=DATA;
ZenACQ_vars.RowName=RowName;
ZenACQ_vars.setup_infos.SX_azimuth=SX_azimuth;
ZenACQ_vars.setup_infos.A_space=A_space;
ZenACQ_vars.setup_infos.S_space=S_space;
ZenACQ_vars.setup_infos.z_positive=z_positive;
ZenACQ_vars.setup_infos.Xstn_box=Xstn_box;
ZenACQ_vars.setup_infos.Ystn_box=Ystn_box;


setappdata(0,'tunnel',ZenACQ_vars);% SET GLOBAL VARIABLE

%OpenFig=findobj('type','figure','name','ZenSurvey');
OpenFig=findobj('type','figure','name','ZenLayout');

if ~ishandle(OpenFig)
close(OpenFig)
end

tequila_status=true;

ZenLayout;


end

