# Instructions tc03b

## Baseline Test

1. In session 1: setup the test case
```
@setup.sql
```

2. In session 1: start ses1 baseline test
**Note:** We don't need ses2 in this baseline test. The sole purpose of this test is to collect a baseline of runtime statistics.
```
@ses1-basline.sql
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
Run the bpftrace scripts ksesecl0-sid-err.bt and kglinv.bt (as user root) to trace ORA-14403 errors and library cache invalidations in real-time.
