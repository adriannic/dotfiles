#!/bin/bash

playerctl metadata --format '{{status}} - [ {{trunc(title,30)}} ] by {{artist}} {{duration(position)}}/{{duration(mpris:length)}}' -F --player=%any --ignore-player=firefox
