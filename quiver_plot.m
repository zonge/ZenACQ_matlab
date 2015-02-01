function [ h ] = quiver_plot(handles,CMP,Ax1,Ax2,Ay1,Ay2,SX_azimut,z_positive,A_space,S_space,theta,color)
% Calculate the X,Y,U,V for Quiver plot

   
if z_positive==2
    degree_offset=-180;
    marker='*';
elseif z_positive==1
    degree_offset=0;
    marker='o';
end


  if strcmp(CMP(1:2),'Ex') || strcmp(CMP(1:2),'TX')
    theta = (mod(180/pi*atan2(Ay2-Ay1,Ax2-Ax1)+SX_azimut-90,360))*-pi/180;
    r = sqrt((Ax1-Ax2)^2+(Ay1-Ay2)^2)*A_space/S_space; % magnitude (length) of arrow to plot
    x = Ax1*A_space/S_space*cos(theta); % Probably need some improvment
    y = Ax1*A_space/S_space*sin(theta); % Probably need some improvment
  
  elseif strcmp(CMP(1:2),'Ey')
    theta = (mod(180/pi*atan2(Ay2-Ay1,Ax2-Ax1)+SX_azimut-90+degree_offset,360))*-pi/180; 
    r = sqrt((Ax1-Ax2)^2+(Ay1-Ay2)^2)*A_space/S_space; % magnitude (length) of arrow to plot

    x = Ay1*A_space/S_space*cos(theta); % Probably need some improvment
    y = Ay1*A_space/S_space*sin(theta); % Probably need some improvment

  elseif strcmp(CMP(1:2),'Hx')
    r = 3;
    theta=(90)*pi/180-theta;
    x=Ax1*A_space/S_space;
    y=Ay1*A_space/S_space;
  elseif strcmp(CMP(1:2),'Hy')
    r = 3;
    theta=(90)*pi/180-theta; 
    x=Ax1*A_space/S_space;
    y=Ay1*A_space/S_space;
  elseif strcmp(CMP(1:2),'Hz')
    x=Ax1*A_space/S_space;
    y=Ay1*A_space/S_space;
    
    h = plot(handles.layout_plot,x,y,'Color',color,'LineStyle','none','Marker',marker);
    hold on
    return ;
  
  end
  
  u = r * cos(theta); % convert polar (theta,r) to cartesian
  v = r * sin(theta);
  
  h = quiver(handles.layout_plot,x,y,u,v,'AutoScaleFactor',1,'MaxHeadSize',0.3,'Color',color);
  hold on  

end

