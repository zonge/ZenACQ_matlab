classdef schedule
    %   OBJECT schedule
    %   Variable and function for the channel object
    
    properties(Constant)

    end
    
    properties
    duration
    sr
    gain
    attenuator
    end
   
    methods
        % Constructor
         function obj=schedule(duration,sr,gain)
                 if nargin==3
                     obj.duration=duration;
                     obj.sr=sr;
                     obj.gain=gain;
                 end  
         end
        
        %  Datatype
%         function Datatype_c=get.Datatype_c(obj)
%             if isnan(obj.Datatype)
%                 Datatype_c=obj.Datatype;
%             elseif obj.Datatype==1
%                     Datatype_c='Binary';
%             elseif obj.Datatype==0
%                     Datatype_c='ANSI';
%             else
%                     Datatype_c=[];
%             end
%
%       end

    end  

end
    
    

