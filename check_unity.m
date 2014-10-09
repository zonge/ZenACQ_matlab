function data=check_unity(dat,tolerance,pourcentage)

% MEDIAN WAY
data=cell(1,1);
for j=1:size(dat,1)
    % CREATE ARRAY OF ROW VALUE TO APPLY MEDIAN
    val=zeros(1,size(dat,2));
    for i=1:size(dat,2)
        val(i)=dat(j,i);
    end
    
    % FIND VALUE OUTSIDE OF THE MEDIAN
    ic=zeros(1,size(dat,2));
    if nargin==2
        UP_VAL=eval(['median(val)+' num2str(tolerance)]);
        MIN_VAL=eval(['median(val)-' num2str(tolerance)]);
    elseif nargin==3
        UP_VAL=eval(['median(val)+median(val)*' num2str(tolerance)]);
        MIN_VAL=eval(['median(val)-median(val)*' num2str(tolerance)]); 
    end
    for i=1:size(dat,2)
        if dat(j,i)>UP_VAL || dat(j,i)<MIN_VAL
            ic(i)=1;
        else
            ic(i)=0;
        end
    end

% CREATE TABLE WITH COLOR

for i=1:size(dat,2)
if sum(ic)>0
     if ic(i)==1
        %IF BIGGER THAN THE STANDARD DEVIATION
        data{j,i} = strcat('<html><body bgcolor="#FF0000" text="#FFFFFF" align="center" width="60px"><b>',num2str(dat(j,i)));
     elseif ic(i)==0
        % IF IN WITHIN THE STANDARD DEVIATION
        data{j,i} = strcat('<html><body bgcolor="#FAC8C8" text="#000000" align="center" width="60px">',num2str(dat(j,i)));
     end
else
        % IF EVERYTHING OK
        data{j,i} = strcat('<html><body bgcolor="#FFFFFF" text="#000000" align="center" width="60px">',num2str(dat(j,i)));
end
end

end

    end