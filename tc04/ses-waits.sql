set lines 200 pages 999
col username for a10
col event for a58
select sid, username, event, to_char(p3, 'xxxxxxxxxxxxxxxx') p3, seq#, blocking_session from v$session where event like 'library cache%' or event like '%AQ%';
