#!/bin/sh

declare -a KEYS
declare -a LIST

function parse_yaml {
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   eval $(
     sed -ne "s|^\($s\):|\1|" \
          -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
          -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
     awk -F$fs '{
        indent = length($1)/2;
        vname[indent] = $2;
        for (i in vname) {if (i > indent) {delete vname[i]}}
        if (length($3) > 0) {
           vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
           printf("KEYS+=(\"%s%s\")\n",vn,$2);
           printf("%s%s=\"%s\"\n", vn,$2, $3);
        }
     }'
   )
}

parse_yaml ec2_list.yml

select select in ${KEYS[@]}; do
  eval "tmp=\$${select}"
  ssh "ubuntu@${tmp}"
  exit
done
