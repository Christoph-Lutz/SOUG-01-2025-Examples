set echo on
-- set autotrace traceonly statistics
update tc_restart set n = n+1 where n = slow(n);
-- set autotrace off
rollback;
