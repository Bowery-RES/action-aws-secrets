#!/bin/bash

set -e

parameters="$PARAMETERS"
prefix="${PREFIX}"
jq_filter="$INPUT_JQ_FILTER"
simple_json="$INPUT_SIMPLE_JSON"
namespace="$NAMESPACE"
if [ -z "$parameters" ]; then
  echo "Invalid argument: parameters is empty" 
fi


format_var_name () {
  name=$(echo "$1" | sed 's/^.//' | if [ "$namespace" = "true" ]; then  tr / _ ; else awk -F/ '{print $NF}'; fi )
  echo "$name" | awk -v prefix="$prefix" -F. '{print prefix $NF}' | tr "[:lower:]" "[:upper:]"
}

get_ssm_param() {
  parameter_name="$1"
  ssm_param=$(aws ssm get-parameter --name "$parameter_name")
  if [ -n "$jq_filter" ] || [ -n "$simple_json" ]; then
    ssm_param_value=$(echo "$ssm_param" | jq '.Parameter.Value | fromjson')
    if [ -n "$simple_json" ] && [ "$simple_json" == "true" ]; then
      for p in $(echo "$ssm_param_value" | jq -r --arg v "$prefix" 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' ); do
        IFS='=' read -r var_name var_value <<< "$p"
        echo "$(format_var_name "$var_name")=$var_value" >> $GITHUB_ENV
      done
    else
      IFS=' ' read -r -a params <<< "$jq_filter"
      for var_name in "${params[@]}"; do
        var_value=$(echo "$ssm_param_value" | jq -r -c "$var_name")
        echo "$(format_var_name "$var_name")=$var_value" >> $GITHUB_ENV
      done
    fi
  else
    var_name=$(echo "$ssm_param" | jq -r '.Parameter.Name')
    var_value=$(echo "$ssm_param" | jq -r '.Parameter.Value')
    echo "$(format_var_name "$var_name")=$var_value" >> $GITHUB_ENV
  fi
}

for parameter in $(echo $parameters | sed "s/,/ /g"); do
  get_ssm_param "$parameter"
done

