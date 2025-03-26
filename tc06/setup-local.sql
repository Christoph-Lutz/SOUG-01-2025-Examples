@vars-remote.sql
@vars-queues.sql
set echo on

-- Cleanup
exec dbms_aqadm.stop_queue(queue_name =>'&&local_queue_name');
exec dbms_aqadm.drop_queue(queue_name =>'&&local_queue_name');
exec dbms_aqadm.drop_queue_table(queue_table=>'&&local_queue_table');

drop database link &&db_link;

-- Setup
create database link &&db_link connect to &&remote_test_user identified by &&remote_test_user_pwd using '//&&remote_test_vip:1521/&&remote_test_service..&&remote_test_domain';

select sysdate from dual@&&db_link;

begin
  dbms_aqadm.create_queue_table(
    queue_table        => '&&local_queue_table',
    queue_payload_type => 'SYS.AQ$_JMS_TEXT_MESSAGE',
    multiple_consumers => TRUE
  );
end;
/
 
begin
  dbms_aqadm.create_queue(
    queue_name  => '&&local_queue_name',
    queue_table => '&&local_queue_table'
  );
  
  dbms_aqadm.start_queue(
    queue_name  => '&&local_queue_name'
  );
end;
/
 
begin
  dbms_aqadm.add_subscriber(
    queue_name     => '&&local_queue_name',
    subscriber     => SYS.AQ$_AGENT('&&consumer', '&&remote_queue_name@&&db_link', null),
    queue_to_queue => true
  );

  dbms_aqadm.schedule_propagation(
    queue_name        => '&&local_queue_name',
    destination       => '&&db_link',
    destination_queue => '&&remote_queue_name',
    start_time        => SYSTIMESTAMP,
    latency           => 0 -- Propagate messages immediately
  );
end;
/
