w
w
#!/usr/bin/env bash

#######################################
# Folders
#
#ALTIDATAHOME /Volume/disk1/altibase
#TRCHOME      $ALTIDATAHOME/trc
#DISKDBHOME   $ALTIDATAHOME/dbs
#MEMDBHOME    $ALTIDATAHOME/dbs
#LOGSHOME     $ALTIDATAHOME/logs
#ARCHIVE_DIR  $ALTIDATAHOME/arch_logs
#######################################

clean_db()
{
    if [ ! -z "$ALTIDATAHOME" ]; then
        rm -fR $ALTIDATAHOME
    fi
}

create_folder()
{
    if [ ! -z "$ALTIDATAHOME" ]; then
        echo "mkdir -p "$ALTIDATAHOME
        mkdir -p $ALTIDATAHOME
    fi
    if [ ! -z "$TRCHOME" ]; then
        echo "mkdir -p "$TRCHOME
        mkdir -p $TRCHOME
    fi
    if [ ! -z "$DISKDBHOME" ]; then
        echo "mkdir -p "$DISKDBHOME
        mkdir -p $DISKDBHOME
    fi
    if [ ! -z "$MEMDBHOME" ]; then
        echo "mkdir -p "$MEMDBHOME
        mkdir -p $MEMDBHOME 
    fi
    if [ ! -z "$LOGSHOME" ]; then
        echo "mkdir -p "$LOGSHOME
        mkdir -p $LOGSHOME
    fi
    if [ ! -z "$ARCHIVE_DIR" ]; then
        echo "mkdir -p "$ARCHIVE_DIR
        mkdir -p $ARCHIVE_DIR
    fi
}

check_has_db()
{
    local retVal="0"
    if [ -z "$ALTIDATAHOME" ]; then
        retVal="3"
    else
        if [ -d "$ALTIDATAHOME" ]; then
            # exist directory
            retVal="1"
            if [ ! -z "$TRCHOME" ]; then
                if [ ! -d "$TRCHOME" ]; then
                    mkdir -p $TRCHOME
                fi
            fi
            if [ ! -z "$DISKDBHOME" ]; then
                if [ ! -d "$DISKDBHOME" ]; then
                    echo "Have no "$DISKDBHOME
                    retVal="2"
                    return
                fi
            fi
            if [ ! -z "$MEMDBHOME" ]; then
                if [ ! -d "$MEMDBHOME" ]; then
                    retVal="2"
                    return "2"
                fi
            fi
            if [ ! -z "$LOGSHOME" ]; then
                if [ ! -d "$LOGSHOME" ]; then
                    retVal="2"
                    return "2"
                fi
            fi
            if [ ! -z "$ARCHIVE_DIR" ]; then
                if [ ! -d "$ARCHIVE_DIR" ]; then
                    retVal="2"
                fi
            fi
        else
            # none exist directory
            retVal="0"
        fi
    fi
    echo "$retVal"
}

result="0"
if [ $# -eq 1 ]
then
    result="3"
else
    result=$(check_has_db)
fi

echo "result="$result

case "$result" in
    *0*)
      echo "create altibase"
      create_folder
      server create MS949 UTF8
      echo "start altibase"
      altibase -n
      ;;
    *2*)
      echo "illegal database"
      echo "clean altibase"
      clean_db
      echo "create altibase"
      create_folder
      server create MS949 UTF8
      echo "start altibase"
      altibase -n
      ;;
    *1*)
      echo "start altibase"
      altibase -n
      ;;
    *)
      echo "enter to bash mode!"
      /bin/bash
      ;;
esac
