# Instructions tc06

## Preparations

1. On source db: setup local queue
```
@setup-local.sql
```

2. On target db: setup remote queue
```
@setup-remote.sql
```

3. On source: db: simulate lgwr hang by suspending it

**Note:** Verify that only a single log writer is active (with adaptive scalable lgwr, the write reqs may be handled by one of the LGnn slave processes rather than by lgwr - in that case, you must suspend the LGnn slaves accordingly).

```
connect / as sysdba

oradebug setorapname lgwr

oradebug suspend
```

## Test Scenario

1. In session 1 on local db: Perform an enqueue operation
```
@enq.sql
```

2. In session 2 on remote db: Perform a dequeue operation
```
@deq.sql
```

3. In session 3 on local db: Simulate an instance crash
```
connect / as sysdba

shutdown abort
```

4. In session 3 on local db: Check enqueued message 
```
select * from local_queue_table
```
