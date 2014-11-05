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
    TX_freq
    end
   
    methods
        % Constructor
         function obj=schedule(duration,sr,gain,TX_freq)
                 if nargin==3
                     obj.duration=duration;
                     obj.sr=sr;
                     obj.gain=gain;
                 elseif nargin==4
                     obj.duration=duration;
                     obj.sr=sr;
                     obj.gain=gain;
                     obj.TX_freq=TX_freq;
                 end  
         end
        
    end  

end
    
    

