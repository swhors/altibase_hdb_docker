#!/usr/bin/env bash

option=0

if [ $# -eq 1 ]; then
    option=$1
else
    echo "Input argument. [0:start,1:enter into hdb,2:stop]"
    exit 0
fi

find_hdb()
{
    local did=`docker ps -a | grep altibase | awk '{print $1}'`
    echo "$did"
}

did=$(find_hdb)


case "$option" in
    *2*)
        if [ ! -z "$did" ]
        then
            echo "HDB will be shutdown.[id="$did"]"
            docker stop $did
            did2=$(find_hdb)
            if [ -z "$did2" ]
            then
                echo "Success to shutdown."
            else
                echo "Fail to shutdown."
            fi
        else
            echo "HDB is not started."
        fi
        ;;
    *1*)
        if [ ! -z "$did" ]
        then
            echo "Enter into HDB docker[id="$did"]"
            docker exec -it $did /bin/bash
        else
            echo "HDB is not started."
        fi
        ;;
    *0*)
        if [ -z "$did" ]
        then
            docker run -d -p 20300:20300 --rm -v /home/wonseo/disk1:/Volume/disk1 altibase
            did2=$(find_hdb)
            if [ -z "$did2" ]
            then
                echo "Fail to run HDB."
            else
                echo "$did2"
            fi
        else
            echo "HDB is already started."
        fi
        ;;
    *)
        echo "Invalid argument."
        ;;
esac
