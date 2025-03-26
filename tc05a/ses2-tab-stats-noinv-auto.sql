set echo off
define sql_id='2yzzuzpyp01ss'

col ddl_no_invalidate for a13 head ddl_no_invl
col is_rolling_invalid for a13 head roll_invl
col is_rolling_refresh_invalid for a17 head roll_refresh_invl
select sql_id, child_number, invalidations, ddl_no_invalidate, is_rolling_invalid, is_rolling_refresh_invalid
from v$sql where sql_id = '&&sql_id';

set echo on
exec dbms_stats.gather_table_stats(ownname=>user, tabname=>'TC_RESTART', estimate_percent=>null, cascade=>true, method_opt=>'for all columns size 1', no_invalidate=>DBMS_STATS.AUTO_INVALIDATE);    
set echo off

select sql_id, child_number, invalidations, ddl_no_invalidate, is_rolling_invalid, is_rolling_refresh_invalid
from v$sql where sql_id = '&&sql_id';

