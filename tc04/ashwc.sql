set echo on
set lines 220 pages 999
@ash_wait_chains.sql event2||'('||substr(to_char(p3,'xxxxxxxxxxxxxxxx'),-1)||')'||':'||blocking_session 1=1 "systimestamp-(2/1440)" "systimestamp"
