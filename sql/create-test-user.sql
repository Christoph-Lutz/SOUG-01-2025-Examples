-- Create test user
-- Note: Adjust for your environment
define pdb='MYPDB'
define test_user='TEST'
define test_user_password='...'
define default_tablespace='USERS'
define temp_tablespace='TEMP'

connect / as sysdba

alter session set container = &&pdb;

-- Remove comment to install dbms_system
-- @?/rdbms/admin/dbmsutil.sql

create user &&test_user identified by &&test_user_password default tablespace users temporary tablespace temp;

grant connect, resource, dba to &&test_user;
grant execute on dbms_aq to &&test_user;
grant execute on dbms_aqadm to &&test_user;
grant execute on dbms_pipe to &&test_user;
grant execute on dbms_session to &&test_user;

alter user &&test_user quota unlimited on &&default_ts;
