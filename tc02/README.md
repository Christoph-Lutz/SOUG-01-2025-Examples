# Instructions tc02

1. In session 1: setup the test case
```
@setup.sql
```

2. In session 2: start 
```
@ses2.sql
```

3. In session 1: start
```
@ses1.sql
```

**Notes:**
Start the bpftrace script update-restarts.bt (as user root) in a shell window to observe write consistency restarts in real-time.
