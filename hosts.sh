#!/usr/bin/env bash
# hosts: Hosts file switcher.
# Author: Shannon Moeller <me@shannonmoeller.com>

# locations
hst=$(readlink -f /etc/hosts)
dir=$HOME/.hosts
cfg=$dir/.config

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
pushd $dir > /dev/null
cat $cfg | tee /dev/stderr | xargs cat local > $hst
popd > /dev/null

# windows
type -P u2d &> /dev/null && echo && u2d $hst
type -P ipconfig &> /dev/null && ipconfig /flushdns
