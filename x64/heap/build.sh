#!/usr/bin/bash

if [ -e "./main.bin" ]; then
  echo "Deleting old binary"
  rm ./main.bin
fi

fasm main.asm main.bin
chmod +x main.bin
