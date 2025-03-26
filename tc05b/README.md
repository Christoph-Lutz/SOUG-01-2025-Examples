# Instructions tc05b

## Preparations

1. In a root shell session: start the bpftrace script ksesecl0.b
```
./bpftrace/ksesecl0-sid-err.bt MYORASID 14403
```

2. In a root shell session: start the bpftrace script kglinv.bt
```
BPFTRACE_STRLEN=40 ./kglinv.bt MYORASID
```

3. In session 1: setup the test case
**Note:** You must manually adjust the setup.sql script for testing with either a global or a local index (this is to say there are no separate setup scripts for global and local indexes).
```
@setup.sql
```

## Scenario 1: table level stats collection with NO_INVALIDATE=TRUE

1. In session 1: start the test query
```
@ses1.sql
```

2. In session 2: collect stats while the query in ses1 is running
```
@ses2-tab-stats-noinv-true.sql
```

## Scenario 2: table level stats collection with NO_INVALIDATE=FALSE

1. In session 1: start the test query
```
@ses1.sql
```

2. In session 2: collect stats while the query in ses1 is running
```
@ses2-tab-stats-noinv-false.sql
```

## Scenario 3: table level stats collection with NO_INVALIDATE=AUTO_INVALIDATE

1. In session 1: start the test query
```
@ses1.sql
```

2. In session 2: collect statis while the query in ses1 is running
```
@ses2-tab-stats-noinv-auto.sql
```

## Scenario 4: partition level stats collection with NO_INVALIDATE=TRUE

1. In session 1: start the test query
```
@ses1.sql
```

2. In session 2: collect stats while the query in ses1 is running
```
@ses2-part-stats-noinv-true.sql
```

## Scenario 5: partition level stats collection with NO_INVALIDATE=FALSE

1. In session 1: start the test query
```
@ses1.sql
```

2. In session 2: collect stats while the query in ses1 is running
```
@ses2-part-stats-noinv-false.sql
```

## Scenario 6: partition level stats collection with NO_INVALIDATE=AUTO_INVALIDATE

1. In session 1: start the test query
```
@ses1.sql
```

2. In session 2: collect stats while the query in ses1 is running
```
@ses2-part-stats-noinv-auto.sql
```

## Scenario 7: online global index rebuild

1. In session 1: start the test query
```
@ses1.sql
```

2. In session 2: rebuild the index
```
@ses2-idx-rebuild.sql
```

## Scenario 8: online global index rebuild with DEFERRED INVALIDATION

1. In session 1: start the test query
```
@ses1.sql
```

2. In session 2: rebuild the index with DEFERRED INVALIDATION 
```
@ses2-idx-rebuild-deferred.sql
```

## Scenario 9: online local index rebuild 

1. In session 1: start the test query
```
@ses1-local.sql
```

2. In session 2: rebuild the index while the query in ses1 is running
```
@ses2-idx-rebuild-local.sql
```

## Scenario 10: online local index rebuild with DEFERRED INVALIDATION

1. In session 1: start the test query
```
@ses1-local.sql
```

2. In session 2: rebuild the index while the query in ses1 is running
```
@ses2-idx-rebuild-local-deferred.sql
```

## Scenario 11: truncate partition

1. In session 1: start the test query
```
@ses1.sql
```

2. In session 2: truncate a partition while the query in ses1 is running
```
@ses2-trunc-part.sql
```
