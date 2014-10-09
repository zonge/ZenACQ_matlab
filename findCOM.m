function [ com ] = findCOM()
try
devices=winqueryreg('name', 'HKEY_LOCAL_MACHINE', 'HARDWARE\DEVICEMAP\SERIALCOMM');
catch
    com{1} = 'NONE';
    return;
end
z=~cellfun(@isempty,strfind(devices, '\Device\Silabser'));      % Cell index

 if sum(z)==0
     com{1} = 'NONE';
 else
     j=0;
     com=cell(sum(z),1);
     for ii=1:length(devices)
        if z(ii)==1
            j=j+1;
            com{j,1} = winqueryreg('HKEY_LOCAL_MACHINE', 'HARDWARE\DEVICEMAP\SERIALCOMM', devices{ii});
        end
     end
 end
end

