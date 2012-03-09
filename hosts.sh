#!/usr/bin/env bash
# hosts: Hosts file switcher.
# Author: Shannon Moeller <me@shannonmoeller.com>

# config
hst=/etc/hosts
dir=$HOME/.hosts
cfg=$dir/.config

# verify
[[ ! -d $dir ]] && mkdir -p $dir
[[ ! -f $cfg ]] && touch $cfg

# show
(( ! $# )) && cat $cfg && exit

# update
lst=( $(cat $cfg) )
for i in "$@"; do
	case "${i:0:1}" in
		+) lst=( ${lst[@]} ${i:1} );;
		-) lst=( ${lst[@]/#${i:1}*/} );;
	esac
done
printf '%s\n' ${lst[@]} | sort -uo $cfg

# build
cd $dir && cat $cfg | tee /dev/stderr | xargs cat local > $hst

# windows
type -P u2d &> /dev/null && echo && u2d $(readlink -f $hst)
type -P ipconfig &> /dev/null && ipconfig /flushdns
