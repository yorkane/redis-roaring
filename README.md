# This module is migrated from [aviggiano](https://github.com/aviggiano/redis-roaring)

Due to the building issues and intergration issues, I've made some changes for easier intergration

## Roaring Bitmaps for Redis as module


## Intro

This project uses the [CRoaring](https://github.com/RoaringBitmap/CRoaring) library to implement roaring bitmap commands for Redis.
These commands can have the same performance as redis' native bitmaps for *O(1)* operations and be [up to 8x faster](#performance) for *O(N)*
calls, according to microbenchmarks, while consuming less memory than their uncompressed counterparts (benchmark pending).

Pull requests are welcome.


## Dependencies
- [CRoaring](https://github.com/RoaringBitmap/CRoaring/releases) (bitmap compression library used by this redis module) 
- Correspond Redis-server's [redismodule.h](https://github.com/RedisLabsModules/RedisModulesSDK/blob/master/redismodule.h) (Replace it as you need)

#### Under Ubuntu
```sh
sudo apt-get install libroaring-dev
```
#### Manual compile
```
# compile and install libroaring.so and header files with version v0.4.0
bash deps.sh
```

## Getting started

```sh
git clone https://github.com/yorkane/redis-roaring.git
cd redis-roaring/
# output module redis-roaring.so
make

# Start redis-server with module:
redis-server --loadmodule redis-roaring.so
```
##### Known issues

- This library only works with [32-bit integeres](https://github.com/RoaringBitmap/CRoaring/issues/1) (e.g. counting numbers up to 4294967296)


## API

The following operations are supported

- `R.SETBIT` (same as [SETBIT](https://redis.io/commands/setbit))
- `R.GETBIT` (same as [GETBIT](https://redis.io/commands/getbit))
- `R.BITOP` (same as [BITOP](https://redis.io/commands/bitop))
- `R.BITCOUNT` (same as [BITCOUNT](https://redis.io/commands/bitcount) without `start` and `end` parameters)
- `R.BITPOS` (same as [BITPOS](https://redis.io/commands/bitpos) without `start` and `end` parameters)
- `R.SETINTARRAY` (create a roaring bitmap from an integer array)
- `R.GETINTARRAY` (get an integer array from a roaring bitmap)
- `R.SETBITARRAY` (create a roaring bitmap from a bit array string)
- `R.GETBITARRAY` (get a bit array string from a roaring bitmap)

Additional commands

- `R.APPENDINTARRAY` (append integers to a roaring bitmap)
- `R.RANGEINTARRAY` (get an integer array from a roaring bitmap with `start` and `end`, so can implements paging)
- `R.SETRANGE` (set or append integer range to a roaring bitmap)
- `R.SETFULL` (fill up a roaring bitmap in integer)
- `R.STAT` (get statistical information of a roaring bitmap)
- `R.OPTIMIZE` (optimize a roaring bitmap)
- `R.MIN` (get minimal integer from a roaring bitmap, if key is not exists or bitmap is empty, return -1)
- `R.MAX` (get maximal integer from a roaring bitmap, if key is not exists or bitmap is empty, return -1)
- `R.DIFF` (get difference between two bitmaps)

Missing commands:

- `R.BITFIELD` (same as [BITFIELD](https://redis.io/commands/bitfield))

## API Example
```
$ redis-cli
# create a roaring bitmap with numbers from 1 to 99
127.0.0.1:6379> R.SETRANGE test 1 100

# get all the numbers as an integer array
127.0.0.1:6379> R.GETINTARRAY test

# fill up the roaring bitmap 
# because you need 2^32*4 bytes memory and a very long time
127.0.0.1:6379> R.SETFULL full

# use `R.RANGEINTARRAY` to get numbers from 100 to 1000 
127.0.0.1:6379> R.RANGEINTARRAY full 100 1000

# append numbers to an existing roaring bitmap
127.0.0.1:6379> R.APPENDINTARRAY test 111 222 3333 456 999999999 9999990
```

## Performance

Tested using CRoaring's `census1881` dataset on the travis build [552223545](https://travis-ci.org/aviggiano/redis-roaring/builds/552223545):

|           OP | TIME/OP (us) | ST.DEV. (us) |
| ------------ | ------------ | ------------ |
|     R.SETBIT |        31.83 |        71.85 |
|       SETBIT |        30.52 |        74.83 |
|     R.GETBIT |        30.29 |        46.99 |
|       GETBIT |        29.30 |        38.39 |
|   R.BITCOUNT |        30.38 |         0.04 |
|     BITCOUNT |       169.46 |         0.95 |
|     R.BITPOS |        30.62 |         0.08 |
|       BITPOS |        55.06 |         0.77 |
|  R.BITOP NOT |       103.90 |         1.71 |
|    BITOP NOT |       328.14 |         5.81 |
|  R.BITOP AND |        40.66 |         0.47 |
|    BITOP AND |       433.52 |         7.98 |
|   R.BITOP OR |        57.01 |         2.33 |
|     BITOP OR |       425.10 |         7.68 |
|  R.BITOP XOR |        60.50 |         2.77 |
|    BITOP XOR |       415.21 |         7.51 |
|        R.MIN |        27.16 |         0.08 |
|          MIN |        24.57 |         0.18 |
|        R.MAX |        24.62 |         0.04 |
|          MAX |        25.85 |         0.03 |
