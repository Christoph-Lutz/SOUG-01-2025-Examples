# Instructions tc03a

## Baseline

1. In session 1: setup the test case
```
@setup.sql
```

2. In session 1: start the test query
```
@ses1.sql
```

3. In session 2: rebuild the index while ses1 query is running
```
@ses2.sql
```

## Variation: DEFERRED INVALIDATION

1. In session 1: start the test query
```
@ses1.sql
```

2. In session 2: rebuild the index with the DEFERRED INVALIDATION clause while ses1 query is running
```
@ses2-deferred.sql
```

**Notes:**
Start the bpftrace script kglinv.bt (as user root) in a shell window to observe library cache invalidations in real-time.

