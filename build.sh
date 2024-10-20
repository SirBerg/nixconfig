#!/bin/sh
today=`date +%m%d`
branch=`(git branch 2>/dev/null | sed -n '/^\* / { s|^\* ||; p; }')`
revision=`(git rev-parse HEAD)`
export NIXOS_LABEL="$today.${revision:0:7}.voyager"
echo Building Boerg Nixconfig Version $NIXOS_LABEL
nixos-rebuild switch
