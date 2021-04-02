#!/usr/bin/bash

set -e

ID="p-$(pwgen 4)"
echo "User id: $ID"

mkdir $ID
cd $ID
cp ../Sort.class.st .
cp ../Observable.class.st .

code .
