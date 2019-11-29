create or replace function to_month(mese int) 
return varchar2
is
  A_month T_month:=T_month('GEN','FEB','MAR','APR','MAG','GIU','LUG','AGO','SET','OTT','NOV','DIC');
  month varchar2 (3);
begin
  month:=A_month(mese);
  return month;
end to_month;

