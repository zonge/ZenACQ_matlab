function [ h ] = quiver_plot(handles,CMP,Ax1,Ax2,Ay1,Ay2,SX_azimuth,z_positive,A_space,S_space,theta,color)
% Calculate the X,Y,U,V for Quiver plot
   
if z_positive==2
    marker='*';
elseif z_positive==1
    marker='o';
end

  if strcmp(CMP(1:2),'Ex') || strcmp(CMP(1:2),'TX') || strcmp(CMP(1:2),'Ey')

    SX_azimuth=(90-SX_azimuth);
    x=Ax1*A_space/S_space;
    y=Ay1*A_space/S_space;
    u = (Ax2-Ax1)*A_space/S_space;
    v = (Ay2-Ay1)*A_space/S_space;
    x2 = x * cosd(SX_azimuth) - y * sind(SX_azimuth);
    y2 = x * sind(SX_azimuth) + y * cosd(SX_azimuth);
    u2 = u * cosd(SX_azimuth) - v * sind(SX_azimuth);
    v2 = u * sind(SX_azimuth) + v * cosd(SX_azimuth);
    u=u2;v=v2;x=x2;y=y2;

  elseif strcmp(CMP(1:2),'Hx') || strcmp(CMP(1:2),'Hy')
    r = 3;
    theta=(90-theta)*pi/180;
    x=Ax1*A_space/S_space;
    y=Ay1*A_space/S_space;
    
    u = r * cos(theta); % convert polar (theta,r) to cartesian
    v = r * sin(theta);
    
    
    
    
  elseif strcmp(CMP(1:2),'Hz')
      
    x=Ax1*A_space/S_space;
    y=Ay1*A_space/S_space;
    
    h = plot(handles.layout_plot,x,y,'Color',color,'LineStyle','none','Marker',marker);
    hold on
    return ;
  
  end

  h = quiver(handles.layout_plot,x,y,u,v,'AutoScaleFactor',1,'MaxHeadSize',0.3,'Color',color);
  hold on  

end

