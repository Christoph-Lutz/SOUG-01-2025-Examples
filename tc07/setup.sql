@vars.sql
set echo on

drop table tc_lost_write purge;
create table tc_lost_write as select level n, 'old' v from dual connect by level <= 10;

exec dbms_stats.gather_table_stats(ownname=>user, tabname=>'TC_LOST_WRITE', estimate_percent=>null, cascade=>true); 

set lines 200 pages 999
select 
  rowid, 
  dbms_rowid.rowid_to_absolute_fno(rowid, user, 'TC_LOST_WRITE') fno,
  dbms_rowid.rowid_block_number(rowid, 'BIGFILE') block_no,
  t.* 
from 
  tc_lost_write t;

alter system checkpoint;
alter system checkpoint;
alter system checkpoint;

alter system flush buffer_cache;
alter system flush buffer_cache;
alter system flush buffer_cache;
