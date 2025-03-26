# Instructions tc01b

1. In session 1: setup the test case and start an update
```
psql -U postgres
\i setup.sql
\i ses1.sql
```

2. In session 2: start the conflicting update
```
psql -U postgres
\i ses2.sql
```

3. In session 1: complete the transactions
```
commit;
```

4. In session 2: check the result
```
select * from tc;
```

**Notes:**
VBox OEL 8.10 postgres install dir: /var/lib/pgsql
