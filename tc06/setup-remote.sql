@vars-remote.sql
@vars-queues.sql
set echo on

-- Cleanup
exec dbms_aqadm.stop_queue(queue_name =>'&&remote_queue_name');
exec dbms_aqadm.drop_queue(queue_name =>'&&remote_queue_name');
exec dbms_aqadm.drop_queue_table(queue_table=>'&&remote_queue_table');

drop table &&remote_test_table purge;
create table &&remote_test_table(ts timestamp, msg varchar2(64));

-- Setup
begin
  dbms_aqadm.create_queue_table(
        queue_table        => '&&remote_queue_table',
        queue_payload_type => 'SYS.AQ$_JMS_TEXT_MESSAGE',
        multiple_consumers => TRUE
    );

    dbms_aqadm.create_queue(
        queue_name => '&&remote_queue_name',
        queue_table => '&&remote_queue_table'
    );

    dbms_aqadm.start_queue(
        queue_name => '&&remote_queue_name'
    );
end;
/
