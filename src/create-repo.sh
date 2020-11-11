#!/usr/bin/env bash


while [ "1" = "1" ]
do
    # Wait for a change before executing createrepo
    inotifywait -r /usr/share/nginx/html -e create,close_write,delete

    # List directories that contain rpm files
    # and for each directory, launch createrepo
    find tests/ -type f -name *.rpm -exec dirname {} \; | sort -u  | while read rpm_dir
    do
        echo "createrepo ${rpm_dir}"
        createrepo ${rpm_dir}
    done
done