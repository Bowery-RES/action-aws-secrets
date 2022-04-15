#!/bin/bash

set -e

secrets="$SECRETS"

for secret in $(echo $secrets | sed "s/,/ /g"); do
  full_name=$(echo "$secret" | tr / _ | awk -v prefix="$prefix" -F. '{print prefix $NF}' | tr "[:lower:]" "[:upper:]")
  name=$(echo "$secret" | sed 's/^.//' | awk -F/ '{print $NF}' | tr "[:lower:]" "[:upper:]")
  sed -i "s/$full_name/$name/" $GITHUB_ENV
done