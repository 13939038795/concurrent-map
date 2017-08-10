#!/bin/bash

type=$1
package="$type"imap

echo "type: $type"
echo "package: $package"

template=`pwd`"/"concurrent_map_template_interface.txt
file=`pwd`"/"$package"/"$package".go"

echo "template: $template"
echo "file: $file"

rm -rf $package
mkdir $package

add_import=""
shard_fun=""
if [[ $type == *"uint64"* ]]; then
    echo "uint64 001"
    add_import='"strconv"'
    shard_fun='uint32(fnv32(strconv.FormatUint(key, 10)))%uint32(m.Shards)'
elif [[ $type == *"uint16"* ]]; then
    echo "uint16 002"
    add_import='"strconv"'
    shard_fun="uint32(fnv32(strconv.Itoa(int(key))))%uint32(m.Shards)"
elif [[ $type == *"uint8"* ]]; then
    echo "uint8 003"
    add_import='"strconv"'
    shard_fun="uint32(fnv32(strconv.Itoa(int(key))))%uint32(m.Shards)"
elif [[ $type == *"uint"* ]]; then
    echo "uint 004"
    add_import='"strconv"'
    shard_fun="uint32(fnv32(strconv.Itoa(int(key))))%uint32(m.Shards)"
elif [[ $type == *"int64"* ]]; then
    echo "int64 005"
    add_import='"strconv"'
    shard_fun="uint32(fnv32(strconv.FormatInt(key, 10)))%uint32(m.Shards)"
elif [[ $type == *"int16"* ]]; then
    echo "int16 006"
    add_import='"strconv"'
    shard_fun='uint32(fnv32(strconv.Itoa(int(key))))%uint32(m.Shards)'
elif [[ $type == *"int8"* ]]; then
    echo "int8 007"
    add_import='"strconv"'
    shard_fun="uint32(fnv32(strconv.Itoa(int(key))))%uint32(m.Shards)"
elif [[ $type == *"int"* ]]; then
    echo "int 008"
    add_import='"strconv"'
    shard_fun="uint32(fnv32(strconv.Itoa(key)))%uint32(m.Shards)"
else
    echo "";
fi
echo "add_import: $add_import";
echo "shard_fun: $shard_fun";

sed "s/{PACKAGE}/$package/g" $template > $file;
sed -i "s/{PACKAGE}/$package/g" "$file"
sed -i "s/{ADD_IMPORT}/$add_import/g" $file
sed -i "s/{SHARD_FUN}/$shard_fun/g" $file
sed -i "s/{KEY}/$type/g" $file

exit 0;

