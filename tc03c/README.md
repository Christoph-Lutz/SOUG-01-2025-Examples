# Instructions tc03c

## Baseline

1. In session 1: setup the test case
```
@setup.sql
```

2. In session 1: start the baseline test
```
@ses1-baseline.sql
```

## DML Retry

1. In session 2: start ses2
```
@ses2.sql
```

2. In session 1: start ses1
```
@ses1.sql
```

**Notes:**
You can optionally run the bpftrace scripts ksesecl0-sid-err.bt and kglinv.bt (as user root) to trace ORA-14403 errors and library cache invalidations in real-time.
