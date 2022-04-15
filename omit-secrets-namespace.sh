#!/bin/bash

set -e

secrets="$SECRETS"

for secret in $(echo $secrets | sed "s/,/ /g"); do
  full_name=$(echo "$secret" | tr / _ | awk -v prefix="$prefix" -F. '{print prefix $NF}' | tr "[:lower:]" "[:upper:]")
  printenv | sed -n -e "/^$full_name/p" | sed  "s/$full_name//" | sed 's/^_//' >> $GITHUB_ENV
done