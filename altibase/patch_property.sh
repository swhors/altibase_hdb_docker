#!/usr/bin/env bash

if [ -z "$TRCHOME" ]; then
	export TRCHOME=$ALTIBASE_HOME/trc
fi

if [ -z "$MEMDBHOME" ]; then
	export MEMDBHOME=$ALTIBASE_HOME/dbs
fi

if [ -z "$DISKDBHOME" ]; then
	export DISKDBHOME=$ALTIBASE_HOME/dbs
fi

if [ -z "$LOGSHOME" ]; then
	export LOGSHOME=$ALTIBASE_HOME/logs
fi

if [ -z "$ARCHIVE_DIR" ]; then
	export ARCHIVE_DIR=$ALTIBASE_HOME/arch_logs
fi

rm -f altibase.properties
while read line
do
	case "$line" in
	  *SERVER_MSGLOG_DIR*)
	    echo "#"$line >> altibase.properties
            echo "SERVER_MSGLOG_DIR = "$TRCHOME >> altibase.properties
	    ;;
	  *AUDIT_LOG_DIR*)
	    echo "#"$line >> altibase.properties
            echo "AUDIT_LOG_DIR = "$TRCHOME >> altibase.properties
	    ;;
          *QUERY_PROF_LOG_DIR*)
	    echo "#"$line >> altibase.properties
            echo "QUERY_PROF_LOG_DIR = "$TRCHOME >> altibase.properties
	    ;;
	  *LOG_DIR*)
	    echo "#"$line >> altibase.properties
            echo "LOG_DIR = "$LOGSHOME >> altibase.properties
	    ;;
	  *MEM_DB_DIR*)
	    echo "#"$line >> altibase.properties
            echo "MEM_DB_DIR = "$MEMDBHOME >> altibase.properties
	    ;;
	  *DEFAULT_DISK_DB_DIR*)
	    echo "#"$line >> altibase.properties
            echo "DEFAULT_DISK_DB_DIR = "$DISKDBHOME >> altibase.properties
	    ;;
	  *LOGANCHOR_DIR*)
	    echo "#"$line >> altibase.properties
            echo "LOGANCHOR_DIR = "$LOGSHOME >> altibase.properties
	    ;;
	  *DOUBLE_WRITE_DIRECTORY*)
	    echo "#"$line >> altibase.properties
            echo "DOUBLE_WRITE_DIRECTORY = "$MEMDBHOME >> altibase.properties
	    ;;
	  *ARCHIVE_DIR*)
	    echo "#"$line >> altibase.properties
            echo "ARCHIVE_DIR = "$ARCHIVE_DIR >> altibase.properties
	    ;;
	  *)
	    echo $line >> altibase.properties
	    ;;
	esac
done < altibase.properties.release

