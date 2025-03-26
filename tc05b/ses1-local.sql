set echo on
drop index i_n_tc_restart;
create index i_n_tc_restart on tc_restart(n) local online;
update tc_restart set n = n+1 where n = slow(n);

rollback;
