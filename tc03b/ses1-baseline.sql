set echo on
set autotrace traceonly statistics
update tc_restart t set t.n = n+1 where n > 0;
set autotrace off
rollback;
