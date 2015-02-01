function [ TX,Serial_list,status ] = read_tx_file( filename )
% Read Zonge TX files and output a TX obj with all
    % the TX serial and there associated parameters

 
%% READ FILE
try
status=true;
fid = fopen(filename,'r');
while ~feof(fid)
    str = textscan(fid, '%s','delimiter','\n');
end
fclose(fid);
data_temp=str{1,1};
catch
end

% check if it is a real AMT antenna file
if isempty(strfind(data_temp{1,1},'<'))
   TX=0;
   Serial_list=0;
   status=false;
   return; 
end

% find start block
blocks_end= cellfun(@isempty,strfind(data_temp,'</'))==0;
data_temp2=data_temp;data_temp2(blocks_end)={'0'};
blocks=find(cellfun(@isempty,strfind(data_temp2,'<'))==0);

TX(1:size(blocks,1),1)=TX_obj(0,0,0,0,0,0);
Serial_list=cell(size(blocks,1),1);
for i=1:size(blocks,1)

 % get end
 block_end=find(strcmp(data_temp(blocks(i):end),[data_temp{blocks(i)}(1) '/' data_temp{blocks(i)}(2:end)]));
 if isempty(block_end); continue ; end
 
Serial=   l_search_key( '$TX.Serial',    data_temp(blocks(i):blocks(i)+block_end(1)-1),'TX.cal');
Type=     l_search_key( '$TX.type',      data_temp(blocks(i):blocks(i)+block_end(1)-1),'TX.cal');
Sense=    l_search_key( '$TX.sense',     data_temp(blocks(i):blocks(i)+block_end(1)-1),'TX.cal');
MaxFreq=  l_search_key( '$TX.maxFREQ',   data_temp(blocks(i):blocks(i)+block_end(1)-1),'TX.cal');
MinFreq=  l_search_key( '$TX.minFREQ',   data_temp(blocks(i):blocks(i)+block_end(1)-1),'TX.cal');
Calibrate=l_search_key( '$TX.Calibrate', data_temp(blocks(i):blocks(i)+block_end(1)-1),'TX.cal');

TX(i,1)=TX_obj(Serial,Type,Sense,MaxFreq,MinFreq,Calibrate);
Serial_list{i,1}=Serial;
end

emptyCells=cellfun(@isempty,Serial_list);
Serial_list(emptyCells)=[];
end

