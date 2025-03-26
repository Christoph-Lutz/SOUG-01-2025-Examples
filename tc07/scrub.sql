@vars.sql
set echo on
alter diskgroup &&dg_name scrub file '&&datafile' power high;
