#!/bin/bash

readarray -t urls < urls.txt

for url in "${urls[@]}"; do
  webname=$(echo "$url" | cut -d . -f 2)
  curl --head "$url" > "$webname.txt"
done
