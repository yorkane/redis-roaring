#!/usr/bin/env bash
# wait for update...

# libroaring building:
#https://github.com/lemire/CRoaringUnityBuild
# version='0.3.4'
# rm -rf src/roaring
# echo https://github.com/RoaringBitmap/CRoaring/releases/download/v0.4.0/roaring.zip
# echo https://github.com/lemire/CRoaringUnityBuild/archive/v${version}.tar.gz
# curl https://github.com/lemire/CRoaringUnityBuild/archive/v${version}.tar.gz -Lk | tar -xvz -C src/
# mv src/CRoar* src/roaring

curl -L https://raw.githubusercontent.com/RedisLabsModules/RedisModulesSDK/master/redismodule.h -o src/redismodule.h