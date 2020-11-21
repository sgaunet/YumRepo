#!/usr/bin/env bash

function createYumRepo 
{
    # List directories that contain rpm files
    # and for each directory, launch createrepo
    find /usr/share/nginx/html/ -type d -name ${REPODATA_FOLDER} | while read rpm_dir
    do
        if [ -z "${IN}" ]
        then
            repodata="${rpm_dir}/../"
        else
            repodata="${rpm_dir}"
        fi

        echo "`date` - createrepo ${repodata}"
        createrepo ${repodata}
    done
}

function endOfChanges
{
    while [ "1" = "1" ] 
    do
        inotifywait -r /usr/share/nginx/html -e create,close_write,delete
        timeend=$(date "+%s")
        echo $timeend > /tmp/timeend
    done
}

function isThisTheEndOfCopy
{
    now=$(date "+%s")
    endOfCopy=$(($(cat /tmp/timeend)+5))

    if [ "$now" -gt "$endOfCopy" ]
    then
        echo "yes"
    else
        echo "no"
    fi
}

endOfChanges &

while [ "1" = "1" ]
do
    TheEndOfCopy="no"
    # Wait for a change before executing createrepo
    inotifywait -r /usr/share/nginx/html -e create,close_write,delete
    while [ "$TheEndOfCopy" = "no" ]
    do
        echo "$(date) - Wait for the end of copy ... "
        sleep 5
        TheEndOfCopy=$(isThisTheEndOfCopy)
        echo "$(date) - TheEndOfCopy=$TheEndOfCopy "
    done

    createYumRepo
done