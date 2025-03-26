set echo on

create or replace function slow(n number) return number as
begin
  sys.dbms_lock.sleep(1);
  return n;
end;
/

drop table tc_restart purge;

create table tc_restart (n number not null, v varchar2(30)) partition by list(n)
(
    partition p1 values(1),
    partition p2 values(2),
    partition p3 values(3),
    partition p4 values(4),
    partition p5 values(5),
    partition p6 values(6),
    partition p7 values(7),
    partition p8 values(8),
    partition p9 values(9),
    partition p10 values(10)
)
enable row movement;

insert into tc_restart select level n, null from dual connect by level <= 9;
commit;

-- create index i_n_tc_restart on tc_restart(n);
create index i_n_tc_restart on tc_restart(n) local;

exec dbms_stats.gather_table_stats(ownname=>user, tabname=>'TC_RESTART', estimate_percent=>null, cascade=>true, method_opt=>'for all columns size 1');

select * from tc_restart;
