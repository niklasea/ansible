#!/usr/bin/env bash

set -e

for file in /config/*.conf
do
	wg-quick up "$file"
done

sleep infinity;
