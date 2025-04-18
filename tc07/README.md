# Instructions tc07

## Preparations
1. On database: temporarily disable db_lost_write_protect during testing on primary and standby.
```
connect / as sysdba

alter system set db_lost_write_protect=none scope=memory sid='*';
``` 

2. On database: create a new test table and take note of the block number.
```
@setup.sql
``` 

3. On db node: map the data block with asmcmd
```
asmcmd mapblk <datafile> <blockno>
```

3. On storage cell: switch off flash and pmem cache via IORM.
<br>**Note:** You need to do that only on the storage cell where the primary data block copy is stored.

```
$ cellcli

  list iormplan detail

  alter iormplan dbplan=(
    (name=<DB_UNIQUE_NAME>, 
          flashcache=off, flashlog=off, 
          pmemcache=off, pmemlog=off
    )
  )

 list iormplan detail
```

4. On db node: restart the test pdb.
```
alter pluggable database <pdb> close immediate instances=all;

alter pluggable database <pdb> open instances=('<instance>');
```

## Test Case

1. On storage cell: calculate the cell disk block offset using the script "celldisk_off_calc.sh" (as user root).
<br>**Note:** The script assumes a block size of 8 KB. If you're using a different block size, supply the <block_size> as argument 3.
```
./celldisk_off_calc.sh <grid_disk> <asm_offset>
``` 

2. On storage cell: extract and save the data blcok using the dd command generated by the script in the previous step.
```
dd if=/dev/sdj of=old_2625115.dmp bs=8192 count=1 skip=2625115
``` 

3. On database: modify the data block, checkpoint it to disk, and flush the buffer cache.
```
@upd.sql
alter system checkpoint;
alter system flush buffer_cache;
```

4. On storage cell: save the new version of the block using dd.
<br>Example:
```
dd if=/dev/sdj of=new_2625115.dmp bs=8192 count=1 skip=2625115
``` 

5. On storage cell: restore the old version of the data block using the dd command generated by the script in step 1.
<br>Example:
```
dd if=old_2625115.dmp of=/dev/sdj bs=8192 count=1 seek=2625115 conv=notrunc
```

6. On the database: read the test table again
```
@sel.sql
```

7. On db instance: check datafile with rman check logical
```
rman target /
@rman-validate.rcv

@rman-validate-mirror-all.rcv
```

8. On ASM instance: scrub the datafile using default settings
<br>**Note:** Run the scrub command on the ASM instance.
```
alter diskgroup <DISK_GROUP> scrub file '<DATAFILE>' power high;
alter diskgroup <DISK_GROUP> scrub file '<DATAFILE>' repair power high;
```

9. On ASM instance: scrub and repair the datafile using "_asm_enable_repair_lostwrite_scrub"=true
<br>**Note:** Run the scrub command on the ASM instance.
```
alter system set "_asm_enable_repair_lostwrite_scrub"=true scope=memory;

alter diskgroup <DISK_GROUP> scrub file '<DATAFILE>' repair power high;

alter system set "_asm_enable_repair_lostwrite_scrub"=false scope=memory;
```

## Cleanup
1. On storage cell: reset the iormplan settings

```
$ cellcli
  alter iormplan dbplan=""
```

2. On database: drop the test user or test pdb.

3. On database: enable db_lost_write_protect again.
