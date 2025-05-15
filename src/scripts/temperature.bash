#!/usr/bin/env bash

readarray -t temps < <(cat /sys/class/thermal/thermal_zone*/temp)

bugged=false
for temp in "${temps[@]}"; do
  if [[ "$temp" -eq 20000 ]]; then
    bugged=true
    break
  fi
done

sum=0
count=0
for temp in "${temps[@]}"; do
  if [[ "$bugged" == true && "$temp" -eq 20000 ]]; then
    continue
  fi
  sum=$((sum + temp))
  count=$((count + 1))
done

echo $((sum / count))
