function [ts_volts]=data_volts(ts,gain)
AVr=2.048;
% Possible implementation of calibration in futur realease 
ts_volts=single(ts).*(AVr/(2^gain*2^31));
end

