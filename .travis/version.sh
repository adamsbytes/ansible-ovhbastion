#!/bin/bash

# Process current version
IFS=',' read -ra current_version_arr <<< "$(tail -1 ./.version)"

# Sanity check, expecting 2 elements (version/description)
if [ ${#current_version_arr[@]} != 2 ]; then
  echo "Expecting two elements from file, found ${#current_version_arr[@]}"
  exit 1
fi

# Sanity check, verify regex for version number and set varible
if [[ ${current_version_arr[0]} =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]; then
  echo "Setting NEW_VERSION_TAG to v${current_version_arr[0]}"
  export NEW_VERSION_TAG="v${current_version_arr[0]}"
else
  echo "Version ${current_version_arr[0]} failed sanity check!"
  exit 1
fi

# Verify multi-word description and set variable
if (echo "${current_version_arr[1]}" | wc -w) > 4; then
  echo "Setting NEW_VERSION_DESCRIPTION to: ${current_version_arr[1]}"
  export NEW_VERSION_DESCRIPTION=${current_version_arr[1]}
else
  echo "Description ${current_version_arr[1]} failed sanity check!"
  exit 1
fi
