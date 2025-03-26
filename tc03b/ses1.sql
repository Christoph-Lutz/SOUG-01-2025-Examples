set echo on
exec pkg_tc_restart_03b.reset

set autotrace traceonly statistics
update tc_restart t set t.n = n+1 where pkg_tc_restart_03b.test_func(t.n) > 0;
set autotrace off
rollback;

exec pkg_tc_restart_03b.stop_ses2
