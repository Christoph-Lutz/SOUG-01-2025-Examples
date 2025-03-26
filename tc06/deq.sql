@vars-queues.sql
set echo on
set serveroutput on size unlimited

declare
  dequeue_options    DBMS_AQ.DEQUEUE_OPTIONS_T;
  message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
  message_handle     RAW(16);
  message            SYS.AQ$_JMS_TEXT_MESSAGE;
begin
  -- Wait up to 10 seconds for a message
  dequeue_options.wait := 10;
  dequeue_options.consumer_name := '&&consumer';
  
  dbms_aq.dequeue(
    queue_name         => '&&remote_queue_name',
    dequeue_options    => dequeue_options,
    message_properties => message_properties,
    payload            => message,
    msgid              => message_handle
  );

  dbms_output.put_line('Message dequeued.');
  insert into &&remote_test_table values(systimestamp, message.text_vc);
end;
/

commit;

set lines 180 pages 999
col ts for a28
col msg for a60
select * from tc_dequeue order by ts;
