#!/bin/sh

function bin_exists()
{
    if [ $( printf "%s" "$PATH" | xargs --no-run-if-empty --delimiter ':' ls 2>/dev/null | grep -c "${1}\$" ) -eq 0 ] ;
    then
        echo "${1} not found! Use before_script to install ${1} and ensure the binary is in \$PATH and is executable!"
        exit 127
    fi
};
