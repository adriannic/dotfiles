#! /usr/bin/env bash

cd ~/.config/wal || exit

cp ./templates/Pywal-ADR.kvconfig tmp1.kvconfig

source ~/.cache/wal/colors.sh

sed "s/{background}/${background}/g" > tmp2.kvconfig < tmp1.kvconfig
sed "s/{foreground}/${foreground}/g" > tmp1.kvconfig < tmp2.kvconfig
sed "s/{accent}/${color5}/g" > tmp2.kvconfig < tmp1.kvconfig
sed "s/{color8}/${color8}/g" > output.kvconfig < tmp2.kvconfig

rm -rf tmp*
