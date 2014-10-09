function  DATA = find_at_freq( DATA,TX_freq,f,MAG,PHASE )

harmonics=1:2:9;

for i=1:size(harmonics,2)

    F_harmonic=harmonics(i)*TX_freq;
    x=find(f==F_harmonic);
    factor=(4/pi)*(TX_freq/F_harmonic);
    
    if isempty(x); 
        DATA.mag(i,1)=0;
        DATA.phase(i,1)=0;  
    else
        
        
        
        DATA.mag(i,1)=MAG(x)/factor;
        DATA.phase(i,1)=PHASE(x)-pi/2*1000; 
    end


end
end

