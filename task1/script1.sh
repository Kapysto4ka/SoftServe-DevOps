#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[Error]${NC} Only root can run this script."
    exit 1
fi

if [ -z "$1" ] || [ -z "$2" ]; then
    echo -e "${RED}[Error]${NC} You need to enter two arguments"
    exit 1
fi

if ! id "$1" &>/dev/null; then
    echo -e "${RED}[Error]${NC} User '$1' does not exist."
    exit 1
fi

if [ ! -d "$2" ]; then
    echo -e "${RED}[Error]${NC} Directory '$2' does not exist."
    exit 1
fi

chown -R "$1" "$2"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[Success]${NC} Ownership of files and folders in '$2' changed to user '$1' successfully."
else
    echo -e "${RED}[Error]${NC} Failed to change ownership. Please check the provided arguments and try again."
fi
