#!/bin/bash
export LANG=en_US.UTF-8
shopt -s nullglob

function dir() {
    name="${1##*/}"
    if [[ -d $1 ]]; then
        ans1=$((ans1+1))
    elif [[ -f $1 ]]; then
        ans2=$((ans2+1))
    else
        return
    fi
    printf "$3$4$name\n"
    local subd=("${1}"/*)
    if [[ -d "${subd[0]}" ]] || [[ -f "${subd[0]}" ]]; then
        true
    else
        return
    fi
    local count=$2
    local i=0
    local f=$3
    local size=${#subd[@]}
    local arg5=$5
    for (( ; i<$size; i++ ))
    {
        local child="${subd[$i]}"
        if [ $arg5 == 0 ];
        then
            l="$f\u0020\u0020\u0020\u0020"
        else
            l="$f\u2502\u00A0\u00A0\u0020"
        fi
        if [ $((i+1)) == $size ];
        then
            r="\u2514\u2500\u2500\u0020"
            dir "$child" "$((1+count))" "$l" "$r" 0
        else
            r="\u251c\u2500\u2500\u0020"
            dir "$child" "$((1+count))" "$l" "$r" 1
        fi
    }
}


cd dir
root="."
[ "$#" -ne 0 ] && root="$1"

printf "$root\n"

root_subd=("${root}"/*)
ans1=0
ans2=0
if [[ -d ${root_subd[0]} ]] || [[ -f ${root_subd[0]} ]]; then
    for (( i=0; i<${#root_subd[@]}; i++ ))
    do
        child=${root_subd[$i]}
        if [ $((i+1)) == ${#root_subd[@]} ];
        then
            dir "$child" 1 "" "\u2514\u2500\u2500\u0020" 0
        else
            dir "$child" 1 "" "\u251c\u2500\u2500\u0020" 1
        fi
    done
fi
dirs="directories"
files="files"
if [ $ans1 == 1 ]; then
    dirs="directory"
fi
if [ $ans2 == 1 ]; then
    files="file"
fi
printf "\n$ans1 $dirs, $ans2 $files\n"