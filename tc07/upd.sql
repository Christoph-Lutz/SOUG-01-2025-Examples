set echo on

update tc_lost_write set v='new';
commit;

set lines 200 pages 999
select 
  rowid, 
  dbms_rowid.rowid_relative_fno(rowid) fno,
  dbms_rowid.rowid_block_number(rowid) block_no,
  t.* 
from 
  tc_lost_write t;

alter system checkpoint;
alter system checkpoint;
alter system checkpoint;

alter system flush buffer_cache;
alter system flush buffer_cache;
alter system flush buffer_cache;
