classdef signal
    
    properties
        name
        path
        ts_data
        ts_time
        ts_start
        ts_end
        GPStime
        err
        err_t
        ADfreq
        gain
        status
        plot_status
        ch
        GPSweek
        Nbsat
        latitude
        longitude
        altitude
        period_divider
        duty_divider
        startbytes
        flag_pos
        build_software
        build_hardware
        Serial
        TX
        RX
        CMP
        STN_ANT
        A_spacing  
        err_minus
        Box_id
        CAL
        MAG_PHASE
    end
    
    methods
          
        function thisSignal=signal(name,path,ts_data,ts_time,ts_start,ts_end,GPStime,err,err_t,ADfreq,gain,status,plot_status,ch, ...
                GPSweek,Nbsat,latitude,longitude,altitude,period_divider,duty_divider,startbytes,flag_pos, ...
            build_software,build_hardware,Serial,TX,RX,CMP,STN_ANT,A_spacing,err_minus,Box_id,CAL)
           
      
        
           if nargin==34
           thisSignal.name=name;
           thisSignal.path=path;
           thisSignal.ts_data=ts_data;
           thisSignal.ts_time=ts_time;
           thisSignal.ts_start=ts_start;
           thisSignal.ts_end=ts_end;
           thisSignal.GPStime=GPStime;
           thisSignal.err=err;
           thisSignal.err_t=err_t;
           thisSignal.ADfreq=ADfreq;
           thisSignal.gain=gain;
           thisSignal.status=status;
           thisSignal.plot_status=plot_status;
           thisSignal.ch=ch;
           thisSignal.GPSweek=GPSweek;
           thisSignal.Nbsat=Nbsat;
           thisSignal.latitude=latitude;
           thisSignal.longitude=longitude;
           thisSignal.altitude=altitude;
           thisSignal.period_divider=period_divider;
           thisSignal.duty_divider=duty_divider;
           thisSignal.startbytes=startbytes;
           thisSignal.flag_pos=flag_pos;
           thisSignal.build_software=build_software;
           thisSignal.build_hardware=build_hardware;
           thisSignal.Serial=Serial;
           thisSignal.TX=TX;
           thisSignal.RX=RX;
           thisSignal.CMP=CMP;
           thisSignal.STN_ANT=STN_ANT;
           thisSignal.A_spacing=A_spacing;
           thisSignal.err_minus=err_minus;
           thisSignal.Box_id=Box_id;
           thisSignal.CAL=CAL;
           thisSignal.MAG_PHASE=[];

           end         
        end
        
        
     %   Set timeserie to start and end time (time variable)
%         function ts_time=get.ts_time(thisSignal)
%             first=find(thisSignal.ts_time==thisSignal.ts_start);
%             last=find(thisSignal.ts_time==thisSignal.ts_end);
%             ts_time=thisSignal.ts_time(first:last,:); 
%         end
%         
%       %   Set timeserie to start and end time (data variable)
%         function ts_data=get.ts_data(thisSignal)
%             first=find(thisSignal.ts_time==thisSignal.ts_start);
%             last=find(thisSignal.ts_time==thisSignal.ts_end);
%             ts_data=thisSignal.ts_data(first:last,:);
%         end
       
%         %%        Set timeserie to start and end time (time variable)
%         function ts_time=get.ts_time(thisSignal)
%             first=find(thisSignal.ts_time==thisSignal.ts_start);
%             last=length(thisSignal.ts_time);
%             ts_time=thisSignal.ts_time(first:last,:); 
%         end
%         
%        %%  Set timeserie to start and end time (data variable)
%         function ts_data=get.ts_data(thisSignal)
%             first=find(thisSignal.ts_time==thisSignal.ts_start);
%             last=length(thisSignal.ts_time);
%             ts_data=thisSignal.ts_data(first:last,:);
%         end
        

         % Set timeserie to start  (data variable)
%         function ts_data=get.ts_data(thisSignal)
%             first=find(thisSignal.ts_time==thisSignal.ts_start);
%             ts_data=thisSignal.ts_data(first:end,:);
%         end
% 
%       %  Set timeserie to start  (time variable)
%         function ts_time=get.ts_time(thisSignal)
%             first=find(thisSignal.ts_time==thisSignal.ts_start)
%             ts_time=thisSignal.ts_time(first:end,:); 
%         end
        

        
    end
    
end

