set echo on

define message_type='tc_message_t'
define queue_name='tc_queue'
define queue_table='tc_queue_table'

-- Cleanup
exec dbms_aqadm.stop_queue(queue_name=>'&&queue_name');
exec dbms_aqadm.drop_queue(queue_Name=>'&&queue_name');
exec dbms_aqadm.drop_queue_table(queue_table=>'&&queue_table');

drop table queue_control purge;
drop table tc purge;
drop view v_tc;

-- Setup 
create table queue_control (
  stop_flag varchar2(1) default 'N' check (stop_flag in ('Y', 'N'))
);

drop table t_tc purge;
create table t_tc (n number not null);
insert into t_tc(n) values(1);
commit;

create unique index iu_n_t_tc on t_tc(n);

create or replace view v_tc as select * from t_tc;

insert into queue_control(stop_flag) values ('N'); 
commit;

create or replace type &&message_type as object (
    message_text varchar2(128)
);
/

exec dbms_aqadm.create_queue_table(queue_table=>'&&queue_table', queue_payload_type=>'&&message_type');
exec dbms_aqadm.create_queue(queue_name=>'&&queue_name', queue_table=>'&&queue_table');
exec dbms_aqadm.start_queue(queue_name=>'&&queue_name');

create or replace package pkg_shared as
    function helper(p_n number) return number;
    procedure dequeue(p_payload in out varchar2);
    procedure stop_processing;
end pkg_shared;
/

create or replace package body pkg_shared as

    function helper(p_n number) return number as
        l_n number;
    begin
        select n into l_n from v_tc where n = p_n;
        return l_n;
    end helper;

    procedure stop_processing as
    begin
        update queue_control set stop_flag = 'Y';
        commit;
    end stop_processing;

    procedure dequeue(p_payload in out varchar2) as
        e_queue_timeout exception;
        pragma exception_init(e_queue_timeout, -25228);
        l_stop_flag          varchar2(1);
        l_dequeue_options    dbms_aq.dequeue_options_t; 
        l_message_properties dbms_aq.message_properties_t; 
        l_message            &&message_type;
        l_message_handle     raw(16);
    begin
        l_dequeue_options.dequeue_mode := dbms_aq.remove;
        -- l_dequeue_options.wait := dbms_aq.forever;   
        l_dequeue_options.wait := 1;

        loop
            select stop_flag into l_stop_flag from queue_control;
            exit when l_stop_flag = 'Y';

            begin
                dbms_aq.dequeue(
                queue_name         => '&&queue_name',
                dequeue_options    => l_dequeue_options,
                message_properties => l_message_properties,
                payload            => l_message,
                msgid              => l_message_handle);

            exception
                when e_queue_timeout then
                null;
            end;
        end loop;

    end dequeue;
end pkg_shared;
/

show err
