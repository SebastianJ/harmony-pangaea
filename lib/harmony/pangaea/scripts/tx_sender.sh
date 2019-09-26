#!/bin/bash

# Author: Sebastian Johnsson - https://github.com/SebastianJ
#

# Harmony Mainnet/Pangaea Tx Sender
version="0.1.0"
script_name="tx_sender.sh"
script_url=""

usage () {
   cat << EOT
Usage: $0 [option] command
Options:
   -w path      the path of the wallet directory
   -f address   address sending the transaction
   -t address   address receiving the transaction
   -a amount    the amount to send
   -x shardID   the shard ID of the sending address
   -y shardID   the shard ID of the receiving address
   -i file      the file containing the input data
   -h           print this help
EOT
}

while getopts "w:f:t:a:x:y:i:h" opt; do
  case ${opt} in
    w)
      wallet_path="${OPTARG%/}"
      ;;
    f)
      from_address="${OPTARG}"
      ;;
    t)
      to_address="${OPTARG}"
      ;;
    a)
      amount="${OPTARG}"
      ;;
    x)
      from_shard="${OPTARG}"
      ;;
    y)
      to_shard="${OPTARG}"
      ;;
    i)
      input_data_file="${OPTARG}"
      ;;
    h|*)
      usage
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [ -z "$wallet_path" ]; then
  echo "You need to supply the wallet path"
  exit 1
fi

if [ -z "$from_address" ]; then
  echo "You need to supply the from address"
  exit 1
fi

if [ -z "$to_address" ]; then
  echo "You need to supply the to address"
  exit 1
fi

if [ -z "$amount" ]; then
  echo "You need to supply the amount"
  exit 1
fi

if [ -z "$from_shard" ]; then
  echo "You need to supply the ID of the sending/from shard"
  exit 1
fi

if [ -z "$to_shard" ]; then
  echo "You need to supply the ID of the receiving/to shard"
  exit 1
fi

if [ -z "$input_data_file" ]; then
  input_data=""
else
  input_data=$(cat ${input_data_file})
  input_data="--inputData ${input_data}"
fi

cd $wallet_path
./wallet.sh -t transfer --from ${from_address} --to ${to_address} --amount ${amount} --shardID ${from_shard} --toShardID ${to_shard} --pass pass: ${input_data}
