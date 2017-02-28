#!/bin/bash

cd /var/dbs;
mysql --user=root --password=password gardes < sosgardes_last.sql
echo "DONE";
