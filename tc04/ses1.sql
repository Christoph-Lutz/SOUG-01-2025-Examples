set echo on
set serveroutput on size unlimited

declare
  l_payload varchar2(64);
begin
  pkg_shared.dequeue(l_payload);
  dbms_output.put_line('msg: ' ||l_payload);
end;
/
