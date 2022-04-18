#!/bin/bash

set -e

secrets="$SECRETS"

for secret in $(echo $secrets | sed "s/%0A/\n/g"); do
  echo "$secret"
  full_name=$(echo "$secret" | tr / _ | tr - _ | awk -v prefix="$prefix" -F. '{print prefix $NF}' | tr "[:lower:]" "[:upper:]")
  echo "$full_name"
  printenv | sed -n -e "/^$full_name/p" | sed  "s/$full_name//" | sed 's/^_//' >> $GITHUB_ENV
done