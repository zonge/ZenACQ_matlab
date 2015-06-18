classdef channel
    %   OBJECT Channels 
    %   Variable and function for the channel object
    
    properties(Constant)
        Baudrate=230400
        InputBufferSize=10485760/16;
    end
    
    properties
        COM
        BoardType
        Board
        BoardSN
        SDin
        Voltage
        version
        Fversion
        ChNb
        BoxNb
        BoxSN
        Nb_of_Files
        List_Files
		PCoeff
		ICoeff
		DCoeff
		SCoeff
		NCoeff
		XCoeff
		LogData
		LogTerminal
		Datatype
        Datatype_c
		Mux
        Umass

    end
   
    methods
        % Constructor
        function obj=channel(COM)
                if nargin==1
                    obj.COM=COM;
                end  
        end
        
        %  Datatype
        function Datatype_c=get.Datatype_c(obj)
            if isnan(obj.Datatype)
                Datatype_c=obj.Datatype;
            elseif obj.Datatype==1
                    Datatype_c='Binary';
            elseif obj.Datatype==0
                    Datatype_c='ANSI';
            else
                    Datatype_c=[];
            end

        end

    end  

end
    
    

