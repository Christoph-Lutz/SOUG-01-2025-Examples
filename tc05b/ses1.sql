set echo on
update tc_restart set n = n+1 where n = slow(n);

rollback;
