#!/usr/bin/env bash

set -e

for file in ${CONFIGURATION_DIR}/*.conf
do
	wg-quick up "$file"
done

sleep infinity;
