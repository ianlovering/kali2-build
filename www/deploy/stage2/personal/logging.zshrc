
LOG_DIR=/root/mission/logs/console

if [ -f ${LOG_DIR}/enable ]; then
        PARENT_COMMAND=$(ps -o comm= ${PPID})
        if [ "x${PARENT_COMMAND}" != "xscript" ]; then
                exec script ${LOG_DIR}/console_$(date +%F-%H:%M:%S).log
        fi
fi

