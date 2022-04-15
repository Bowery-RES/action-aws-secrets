#!/bin/bash

set -e

secrets="$SECRETS"

for secret in $(echo $secrets | sed "s/,/ /g"); do
  full_name=$(echo "$secret" | tr / _ | awk -v prefix="$prefix" -F. '{print prefix $NF}' | tr "[:lower:]" "[:upper:]")
#   name=$(echo "$secret" | sed 's/^.//' | awk -F/ '{print $NF}' | tr "[:lower:]" "[:upper:]")
  prefix=$(echo "$secret" | awk 'BEGIN{FS=OFS="/"}{NF--; print}' | tr / _ | tr "[:lower:]" "[:upper:]")
  cat .env | sed -n -e "/^$full_name/p" | sed  "s/$full_name//" | cut -c2- >> $GITHUB_ENV
done