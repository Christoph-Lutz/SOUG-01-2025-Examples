@vars-remote.sql
@vars-queues.sql
set echo on

-- Cleanup local
exec dbms_aqadm.stop_queue(queue_name =>'&&local_queue_name');
exec dbms_aqadm.drop_queue(queue_name =>'&&local_queue_name');
exec dbms_aqadm.drop_queue_table(queue_table=>'&&local_queue_table');

drop database link &&db_link;

-- cleanup remote
exec dbms_aqadm.stop_queue(queue_name =>'&&remote_queue_name');
exec dbms_aqadm.drop_queue(queue_name =>'&&remote_queue_name');
exec dbms_aqadm.drop_queue_table(queue_table=>'&&remote_queue_table');

drop table &&remote_test_table purge;
