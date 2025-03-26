set echo on

create or replace function slow(n number) return number as
begin
  dbms_session.sleep(1);
  return n;
end;
/

show err

drop table tc_restart purge;

create table tc_restart as select level n, rpad('x', 64, 'x') pad from dual connect by level <= 10;
create index i_n_tc_restart on tc_restart(n);

exec dbms_stats.gather_table_stats(ownname=>user, tabname=>'TC_RESTART', estimate_percent=>null, cascade=>true, method_opt=>'for all columns size 1');

select * from tc_restart;
