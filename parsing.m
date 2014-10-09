function [ VARIABLE ] = parsing( CELL,STRING,DELIMITER,POSITION )

  A=~cellfun('isempty',strfind(lower(CELL),lower(STRING)));
  if sum(A)~=0
  AA=CELL{A,1};
  Z=textscan(AA,'%s','delimiter',DELIMITER);
  VARIABLE=Z{1,1}{POSITION,1};
  else
  VARIABLE='';
  end

end