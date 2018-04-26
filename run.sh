#!/bin/bash

/usr/sbin/php-fpm7.2 -D
status=$?
if [ $status -ne 0 ]; then
    echo "Failed to start php-fpm7.2: $status"
    exit $status
fi

/usr/sbin/apache2ctl -D FOREGROUND
status=$?
if [ $status -ne 0 ]; then
    echo "Failed to start apache2ctl: $status"
    exit $status
fi

while sleep 60; do
    ps aux | grep php-fpm7.2 | grep -q -v grep
    PROCESS_1_STATUS=$?

    ps aux | grep apache2ctl | grep -q -v grep
    PROCESS_2_STATUS=$?

    # If the greps above find anything, they exit with 0 status
    # If they are not both 0, then something is wrong
    if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
        echo "One of the processes has already exited."
        exit 1
    fi
done
