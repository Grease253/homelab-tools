#!/bin/bash

# Check for internet connectivity
if ! ping -c 1 google.com &> /dev/null; then
  echo "Error: No internet connection."
  exit 1
fi

# Update package lists
if ! sudo apt update; then
  echo "Error: Failed to update package lists."
  exit 1
fi

# Upgrade installed packages
if ! sudo apt upgrade -y; then
  echo "Error: Failed to upgrade packages."
  exit 1
fi

# Perform a full upgrade
if ! sudo apt full-upgrade -y; then
  echo "Error: Failed to perform full upgrade."
  exit 1
fi

# Clean up unnecessary packages
if ! sudo apt autoremove -y; then
  echo "Error: Failed to clean up unnecessary packages."
  exit 1
fi

echo "Raspbian OS update and upgrade complete."
