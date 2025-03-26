@vars-queues.sql
set echo on

-- Enqueue a test message into the local queue
declare
  enqueue_options    DBMS_AQ.ENQUEUE_OPTIONS_T;
  message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
  message_handle     RAW(16);
  message            SYS.AQ$_JMS_TEXT_MESSAGE;
begin
  message := SYS.AQ$_JMS_TEXT_MESSAGE.CONSTRUCT;
  message.set_text('Test msg for propagation');

  dbms_aq.enqueue(
      queue_name         => '&&local_queue_name',
      enqueue_options    => enqueue_options,
      message_properties => message_properties,
      payload            => message,
      msgid              => message_handle
   );
end;
/

commit;
