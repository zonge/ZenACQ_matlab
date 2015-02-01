classdef TX_obj
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Serial
        Type
        Sense
        MaxFreq
        MinFreq
        Calibrate
    end
    
    methods
        % Constructor
        function obj=TX_obj(Serial,Type,Sense,MaxFreq,MinFreq,Calibrate)
                if nargin==6
                    obj.Serial=Serial;
                    obj.Type=Type;
                    obj.Sense=Sense;
                    obj.MaxFreq=MaxFreq;
                    obj.MinFreq=MinFreq;
                    obj.Calibrate=Calibrate;
                    
                end  
        end
    end
    
end

