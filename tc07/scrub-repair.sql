@vars.sql
set echo on

show parameter ""_asm_enable_repair_lostwrite_scrub"

alter system set "_asm_enable_repair_lostwrite_scrub"=true scope=memory;

alter diskgroup &&dg_name scrub file '&&datafile' repair power high;

alter system set "_asm_enable_repair_lostwrite_scrub"=false scope=memory;

show parameter "_asm_enable_repair_lostwrite_scrub"
