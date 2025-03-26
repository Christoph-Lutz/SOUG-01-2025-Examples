set echo on

alter system flush buffer_cache;

set lines 200 pages 999
select 
--  rowid, 
--  dbms_rowid.rowid_relative_fno(rowid) fno,
--  dbms_rowid.rowid_block_number(rowid) block_no,
  t.* 
from 
  tc_lost_write t;

alter system flush buffer_cache;
