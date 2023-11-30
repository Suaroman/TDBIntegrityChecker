#!/bin/bash

pad_right() {
    printf "%-*s" "$2" "$1"
}

printf "%-30s %-10s %-15s\n" "Database File" "Status" "Record Count"
printf "%-30s %-10s %-15s\n" "------------------------------" "----------" "---------------"

lsof | grep '\.tdb$' | awk '{print $9}' | sort -u | while read -r tdbfile; do
    if [[ -n $tdbfile ]]; then
        base_name=$(basename "$tdbfile")
        read -r status records <<< $(echo -e "check\nquit" | tdbtool "$tdbfile" | sed -n 's/.*is \(.*\) and has \([0-9]*\) records./\1 \2/p')
        
        padded_name=$(pad_right "$base_name" 30)
        printf "%s %-10s %-15s\n" "$padded_name" "$status" "$records"
    fi
done
