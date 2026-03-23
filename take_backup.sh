#!/bin/bash

function check_usage {
    echo "please give source path and destination path for backup.sh file"
    echo "example: ./backup.sh /home/ubuntu/data /home/ubuntu/backup_folder"
}
source_dir=$1
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
backup_dir=$2
function create_backup {
    zip -r "${backup_dir}/backups_${timestamp}.zip" "${source_dir}" > /dev/null
    if [ $? -eq 0 ]; then
            echo "backup generated successfully"
    fi
}
if [ $# -eq 0 ]; then
  check_usage
fi
function create_rotation {
        backups=($(ls -t "${backup_dir}/backups"*.zip 2>/dev/null))
       if [ "${#backups[@]}" -gt 5 ]; then
                 echo "creating rotation for 5 days"

                backup_to_remove=("${backups[@]:5}")
                for backup in "${backup_to_remove[@]}";
                do
                        rm -f "${backup}"
                done
       fi
}
create_backup
create_rotation