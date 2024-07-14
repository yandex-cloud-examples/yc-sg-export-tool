#!/bin/bash

# ======================================================
# Create SG and SG Rules list for the specified cloud-id
# Required tools: yc CLI, jq
# ======================================================
set -e

if [ -n "$1" ]; then
  SG_FILE="cloud-$1-sg-list.csv"
  rm -f $SG_FILE 2>/dev/null

  FLD_LST=$(yc resource-manager folder list --cloud-id=$1 --format=json | jq -r '.[] .name' | tr "\n" " ")
  
  # Write header to the file
  echo '"folder_name","folder_id","network_id","status","sg_id","sg_name","sg_description","created_at","rule_id","rule_direction","rule_description","port_from","port_to","protocol_name","protocol_number","cidr_ipv4"' > $SG_FILE

  # List SG with rules
  for fld in $FLD_LST; do echo Processing folder: $fld; 
    # List SG with rules
    yc vpc security-group list --folder-name=$fld --format=json | jq --arg fld "$fld" -r '.[] |
    .id as $sg_id | .name as $sg_name | .description as $sg_descr | .folder_id as $fld_id | .network_id as $net_id | .status as $status | .created_at as $date |
    try .rules[] | [$fld, $fld_id, $net_id, $status, $sg_id, $sg_name, $sg_descr, $date, .id, .direction, .description,
    .ports.from_port, .ports.to_port, .protocol_name, .protocol_number, .cidr_blocks.v4_cidr_blocks|tostring] | @csv' >> $SG_FILE

    # List empty SG (with no rules)
    yc vpc security-group list --folder-name=$fld --format=json | jq --arg fld "$fld" -r '.[] | select(.rules == null) |
    [$fld, .folder_id, .network_id, .status, .id, .name, .description, .created_at, "EMPTY-SG", 
    "null", "null", "null", "null", "null", "null", "null"] | @csv' >> $SG_FILE
  done
  
  # Clean up the "cidr_ipv4" field
  sed -r -e 's/(""|""\]|\["")//g' $SG_FILE > $SG_FILE.tmp
  mv $SG_FILE.tmp $SG_FILE

  printf "\nSG Report file: $SG_FILE\n"

else
  printf "No cloud_id was specified!\n\n"
  printf "For example:\n$0 <cloud-id>\n"
fi
  exit
