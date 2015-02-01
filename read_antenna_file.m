function [ ant,antennas,status ] = read_antenna_file( filename )
% Read Zonge antenna files and output a ant structure with all
    % the antenna serial and there associated found cal

try   
%% READ FILE
status=true;
fid = fopen(filename,'r');

while ~feof(fid)
    str = textscan(fid, '%s','delimiter','\n');
end

fclose(fid);
data_temp=str{1,1}; clear str;

catch
end
% check if it is a real AMT antenna file
if isempty(strfind(data_temp{1,1},'AMT antenna'))
   ant=0;
   antennas=0;
   status=false;
   return; 
end

% delete empty line
j=0;
data=cell(size(data_temp,1),1);
for i=1:size(data_temp,1)
    if ~isempty(data_temp{i,1})
        j=j+1;
        data{j,1}=data_temp{i,1};
    end   
end
data(j+1:end)=[];
    
% Organize data
Block_header=find(cellfun(@isempty,strfind(data,'AMT antenna'))==0);
Block_header(end+1)=size(data,1)+1;
k=0;
cal=zeros(size(data,1)-size(Block_header,1)+1,6);
for i=1:size(Block_header,1)-1 
    block_title=textscan(data{Block_header(i),1},'%s %s %f');
    for j=Block_header(i)+1:Block_header(i+1)-1
    	k=k+1;
    	cal(k,1)=block_title{1,3};
        cal(k,2:6)=cell2mat(textscan(data{j,1},'%f %f %f %f %f'));
    end    
end

%% CREATE

% find Antenna #
antennas=unique(cal(:,2));
ant=struct('sn',0,'cal',0);
for i=1:size(antennas,1)
    % Get antenna number
    ant(i).sn=antennas(i);
    
    % Get calibration
    index=find(cal(:,2)==ant(i).sn);
    k=1;
    cal_temp=zeros(size(index,1)*2,3);
    for j=1:size(index,1)
       cal_temp(k,1)=2^(round(log2(cal(index(j),1))))*6;
       cal_temp(k,2)=cal(index(j),3);
       cal_temp(k,3)=cal(index(j),4);
       k=k+1;
       cal_temp(k,1)=2^(round(log2(cal(index(j),1))))*8;
       cal_temp(k,2)=cal(index(j),5);
       cal_temp(k,3)=cal(index(j),6);
       k=k+1;
    end
    cal_temp=sort(cal_temp,1);
    ant(i).cal=cal_temp;
    
end
   

end

