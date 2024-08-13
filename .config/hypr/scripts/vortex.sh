#! /usr/bin/env bash

function getcolor() {
  ydotool mousemove --absolute -x 0 -y 0
  TEST=$( (
    hyprpicker &
    sleep '0.1' && ydotool mousemove --absolute -x "$1" -y "$2" && sleep '0.1' && ydotool click 0xC0
  ) | head -n1)
  echo "$TEST"
}

while :; do
  CLICKED="false"
  for i in 280 290 300 310 320 330 340 350 360 370 380 390 400 410 420 430 440; do
    COLOR=$(getcolor 750 $i)
    if [[ $COLOR = "#C87B28" ]]; then
      sleep '0.1'
      ydotool mousemove --absolute -x 750 -y $i
      ydotool click 0xC0
      sleep 1
      CLICKED="true"
      break
    elif [[ $COLOR = "#9E6120" ]]; then
      sleep '0.1'
      ydotool mousemove --absolute -x 750 -y $i
      ydotool click 0xC0
      sleep 1
      CLICKED="true"
      break
    fi
    continue
  done

  if [[ $CLICKED = "false" ]]; then
    ydotool click 0xC0
    sleep 3
    continue
  fi

  for i in 730 720 710 700 690 680 670 660 650 640 630 620 610 600; do
    if [[ $(getcolor 1418 $i) = "#DDDDDD" ]]; then
      ydotool mousemove --absolute -x 1418 -y $i
      ydotool click 0xC0
      break
    fi
  done
  sleep 5
  ydotool mousemove --absolute -x 1440 -y 25
  ydotool click 0xC0
done
