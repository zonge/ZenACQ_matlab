classdef TX_object
    
    properties
        id
        Serial
        Type
        sense
        maxFREQ
        minFREQ
        Calibrate  
    end
    
    
    methods
        
        % CONSTRUCTOR  
        function TX_infos=TX_infos(id,Serial,Type,sense,maxFREQ,minFREQ,Calibrate) 
           if nargin==7
           TX_infos.id=id;
           TX_infos.Serial=Serial;
           TX_infos.Type=Type;
           TX_infos.id=sense;
           TX_infos.Serial=maxFREQ;
           TX_infos.Type=minFREQ;
           TX_infos.Calibrate=Calibrate;
           end         
        end
        

    end  
end

