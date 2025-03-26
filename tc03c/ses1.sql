set echo on
exec pkg_tc_restart_03c.reset

set autotrace traceonly statistics
update tc_restart t set t.n = n+1 where pkg_tc_restart_03c.test_func(t.n) > 0;
set autotrace off

exec pkg_tc_restart_03c.stop_ses2
