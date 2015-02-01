    function [ string ] = GetString(data,Lookup,delim,pos1,pos2)
    % if delim == 0 . second delimiter is the end of the line.
    if nargin<=3;
        pos1=1; pos2=1;
    elseif nargin==4
        pos2=1;
    end

if isempty(data)
    string='NoDataReceived';
    return;
end
        
if strcmp(data.Query,'EmptyQuery') 
    string='NoDataReceived';
    return;
end

if isempty(Lookup)
    string='';
    return;
end

% merge the entire response
d=data.Query;
clear data;
s=strjoin(d');
s(s==' ')=[];
data.Query{1,1}=deblank(s);

%disp(data.Query)

x = strfind(data.Query,Lookup);
z=find(~cellfun(@isempty,x),1);        % Cell index

if isempty(z)
    string='NoReceivedData';
    return;
end

string_s=x{z(pos2),1}+size(Lookup,2);      % Start character

if nargin==3 || nargin==4 || nargin==5
    if delim==0
        string=data.Query{z(pos2),1}(string_s(1)-length(Lookup):end);
    else
        string_e=strfind(data.Query{z(pos2),1}(string_s:end),delim); %Nb of character(s)
        if isempty(string_e)
            string='NoReceivedData';
        else
            string=data.Query{z(pos2),1}(string_s(1):string_s(1)+string_e(pos1)-2);
        end
    end
else
    string=data.Query{z(pos2),1}(string_s(1):end);
end

end