/* 
 * Purpose:
 *
 * Author:
 *   Christoph Lutz
 *
 * Date:
 *   Feb-22 2025
 *
 * Tested on:
 *   Oracle 19.23
 * 
 * Usage:
 *   Create a test table and load the plsql package with the 
 *   test code:
 *
 *   @setup.sql
 *
 *   When setup is complete, open two new sessions and start 
 *   the test procedures (ses2 must be started first).
 *  
 *   Session 2: @ses2.sql
 *   Session 1: @ses1.sql
 *
 * Notes:
 *   To enable printing debug output change the G_DEBUG flag.
 *   Debug output will be written to the alert log.
 */

create or replace package pkg_tc_restart_03c as
    G_DEBUG      boolean               := FALSE;
    G_STARTS     pls_integer           := 0;
    PIPE_SES1    constant varchar2(32) := 'PIPE_SES1';
    PIPE_SES2    constant varchar2(32) := 'PIPE_SES2';
    CMD_REBUILD  constant varchar2(32) := 'REBUILD';
    CMD_CONTINUE constant varchar2(32) := 'CONTINUE';
    CMD_STOP     constant varchar2(32) := 'STOP';
    procedure    reset;
    procedure    start_ses1;
    procedure    start_ses2;
    procedure    stop_ses2;
    function     test_func(p_n number) return number;
end pkg_tc_restart_03c;
/

create or replace package body pkg_tc_restart_03c as

    procedure reset as
    begin
        dbms_session.reset_package;
        dbms_pipe.purge(PIPE_SES1);
        dbms_pipe.purge(PIPE_SES2);
    end reset;

    procedure debug(p_msg varchar2) as
    begin
        if G_DEBUG then
            sys.dbms_system.ksdwrt(sys.dbms_system.alert_file, p_msg);
        end if;
    end debug;

    procedure send(p_pipe in varchar2, p_msg in varchar2) as
        l_status number;
    begin
        dbms_pipe.pack_message(p_msg);
        l_status := dbms_pipe.send_message(p_pipe);
        if l_status != 0 then
            raise_application_error(-20001, 'Pipe send failed');
        end if;
    end send;

    procedure receive(p_pipe in varchar2, p_msg out varchar2) as
        l_res number;
    begin
        l_res := dbms_pipe.receive_message(p_pipe, DBMS_PIPE.maxwait);
        if l_res = 0 then
            dbms_pipe.unpack_message(p_msg);
        else
            raise_application_error('-20002', 'Pipe receive failed. Return: ' ||l_res);
        end if;
    end receive;

    function test_func(p_n number) return number as
        l_msg varchar2(32);
    begin
        debug(to_char(systimestamp, 'hh24:mi:ss.ff9') ||': ses1: test_func: entry: p_n='||p_n);

        /* Uncomment to delay processing */
        /* dbms_session.sleep(1);        */

        /*
         * Notify ses2 to execute a small update statement.
         * This assumes that n is equal to 1 on first iteration, so 
         * note that this is only the case when the test data set is
         * packed in a single block. This means, with larger data 
         * sets (stored in multiple blocks) you may have to enforce
         * an index based access path for the update executed by ses1
         * as the processing order will not be deterministic otherwise).
         */
        if p_n = 1 then
            G_STARTS := G_STARTS + 1;
        end if;

        if p_n = 4 and G_STARTS = 1 then
            debug(to_char(systimestamp, 'hh24:mi:ss.ff9') ||': ses1: test_func: send: p_n='||p_n);
            send(PIPE_SES2, CMD_REBUILD);
         
            /* Note: no need to check what msg exactly we're receiving here. */
            receive(PIPE_SES1, l_msg);
            debug(to_char(systimestamp, 'hh24:mi:ss.ff9') ||': ses1: test_func: received: l_msg='||l_msg);
        end if;

        debug(to_char(systimestamp, 'hh24:mi:ss.ff9') ||': ses1: test_func: ret: p_n='||p_n);
        return p_n;
    end test_func;

    procedure start_ses1 as
    begin
        update tc_restart t set t.n = n+1 where test_func(t.n) > 0;
    end start_ses1;

    procedure start_ses2 as
        l_n number;
        l_msg varchar2(32);
    begin
        loop
            receive(PIPE_SES2, l_msg);

            if l_msg = CMD_REBUILD then
                debug(to_char(systimestamp, 'hh24:mi:ss.ff9') ||': ses2: rebuilding index ...');
                execute immediate 'alter index i_n_tc_restart rebuild partition P5 online deferred invalidation';
                send(PIPE_SES1, CMD_CONTINUE);
                debug(to_char(systimestamp, 'hh24:mi:ss.ff9') ||': ses2: index rebuild complete.');
            end if;

        exit when l_msg = CMD_STOP;
        end loop;
    end start_ses2;

    procedure stop_ses2 as
    begin
        send(PIPE_SES2, CMD_STOP);
    end stop_ses2;

end pkg_tc_restart_03c;
/

show error
