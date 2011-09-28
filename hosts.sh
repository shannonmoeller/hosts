#!/usr/bin/env bash
# hosts: Hosts file switcher.
# Author: Shannon Moeller <me@shannonmoeller.com>

dir=~/.hosts
fil=/etc/hosts

# current hosts list
lis=( $(sed -n 's/^#@//p' $fil) )

# print sorted list
prt() {
	printf '%s\n' ${lis[@]} | sort -u
}

# print and exit
(( ! $# )) && prt && exit

# modify hosts list
for i in "$@"; do
	case "${i:0:1}" in
		+) lis=( ${lis[@]} ${i:1} );;
		-) lis=( ${lis[@]/#${i:1}*/} );;
	esac
done

# reset hosts file
cat "$dir/local" > $fil

# append listed hosts files
for i in $(prt); do
	if [[ -f "$dir/$i" ]]; then
		printf '\e[0;32m* %s\e[0m\n' $i
		printf '#@%s\n' $i >> $fil
		cat "$dir/$i" >> $fil
	else
		printf '\e[0;31m! %s\e[0m\n' $i
	fi
done

# force dos endings
type -P u2d &>/dev/null && cat $fil | u2d > $fil
