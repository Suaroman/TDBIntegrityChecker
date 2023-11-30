# TDB Integrity Checker

This script is a utility for checking the integrity of Winbind TDB (Trivial Database) files on a system. It lists all currently open `.tdb` files, checks their integrity using `tdbtool`, and presents the results in a formatted table with the file name, status, and the record count.

## Download and Run

To use the TDB Integrity Checker script, you can download it directly from the repository using `wget` with the following command:

```bash
wget https://raw.githubusercontent.com/Suaroman/TDBIntegrityChecker/master/tdb-integrity-check.sh
chmod +x tdb-integrity-check.sh
```

HDInsight ESP clusters have `tdbtool` already installed.

## Usage

To run the script, navigate to the directory where the script is located and run:

```bash
./tdb-integrity-check.sh
```

The output will be displayed in a neatly formatted table directly in your terminal.

## Sample Output

Here's an example of what the output might look like after running the script:

```
Database File                  Status     Record Count
------------------------------ ---------- ---------------
g_lock.tdb                     OK         0
gencache_notrans.tdb           OK         9
names.tdb                      OK         1
serverid.tdb                   OK         1
gencache.tdb                   OK         40
netsamlogon_cache.tdb          OK         0
group_mapping.tdb              OK         0
netlogon_creds_cli.tdb         OK         2
secrets.tdb                    OK         10
winbindd_cache.tdb             OK         9441
winbindd_idmap.tdb             OK         3
```

## Script Example

Below is the script that will be executed:

```bash
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
```

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

Don't forget to give the project a star! Thanks again!

