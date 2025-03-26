#!/usr/bin/bash

for i in {1..50} 
 do
    sqlplus /nolog <<EOF &
    @connect.sql
    select pkg_shared.helper(1) from dual;
    exit
EOF
done
