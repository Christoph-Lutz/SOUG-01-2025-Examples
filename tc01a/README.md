# Instructions tc01a

1. In session 1: setup the test case and start an update
```
@setup.sql
@ses1.sql
```

2. In session 2: start a conflicting update
```
@ses2.sql
```

3. In session 1: complete the transaction
```
commit;
```

4. In session 2: check the result
```
select * from tc;
```
