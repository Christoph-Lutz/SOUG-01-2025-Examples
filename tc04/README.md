# Instructions tc04

1. In session 1: setup the test case
```
@setup.sql
```

2. In session 1: start the dequeue
```
@ses1.sql
```

3. In session 2: drop the index
```
@ses2.sql
```

4. In session 3: call the helper function
```
@ses3.sql
```

5. In session 4 (shell): simulate sessions / load
```
./load.sh
```

6. In session 5: analyze session activity
```
@ses-waits.sql
@asht.sql
@ashwc.sql
```

7. In session 1: resolve the hang
Hit ctrl + c
