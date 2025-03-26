set echo on

col ddl_no_invalidate for a13 head ddl_no_invl
col is_rolling_invalid for a13 head roll_invl
col is_rolling_refresh_invalid for a13 head roll_ref_invl
select sql_id, child_number, invalidations, ddl_no_invalidate, is_rolling_invalid, is_rolling_refresh_invalid
from v$sql where sql_id = '2yzzuzpyp01ss';

alter index i_n_tc_restart rebuild online deferred invalidation;

select sql_id, child_number, invalidations, ddl_no_invalidate, is_rolling_invalid, is_rolling_refresh_invalid
from v$sql where sql_id = '2yzzuzpyp01ss';
