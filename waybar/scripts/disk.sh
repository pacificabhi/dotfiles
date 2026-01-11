#!/bin/bash

# Get disk usage for root partition
ROOT_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
ROOT_USED=$(df -h / | awk 'NR==2 {print $3}')
ROOT_TOTAL=$(df -h / | awk 'NR==2 {print $2}')

# Check if home is on a separate partition
HOME_PARTITION=$(df -h /home | awk 'NR==2 {print $1}')
ROOT_PARTITION=$(df -h / | awk 'NR==2 {print $1}')

if [ "$HOME_PARTITION" != "$ROOT_PARTITION" ]; then
    HOME_USAGE=$(df -h /home | awk 'NR==2 {print $5}' | sed 's/%//')
    HOME_USED=$(df -h /home | awk 'NR==2 {print $3}')
    HOME_TOTAL=$(df -h /home | awk 'NR==2 {print $2}')

    # Choose icon based on higher usage
    if [ $ROOT_USAGE -gt $HOME_USAGE ]; then
        USAGE=$ROOT_USAGE
    else
        USAGE=$HOME_USAGE
    fi

    # Determine icon based on usage
    if [ $USAGE -ge 90 ]; then
        ICON=""
        CLASS="critical"
    elif [ $USAGE -ge 70 ]; then
        ICON=""
        CLASS="warning"
    else
        ICON=""
        CLASS="normal"
    fi

    echo "{\"text\":\"${ROOT_USED}/${ROOT_TOTAL}\", \"tooltip\":\"Root: ${ROOT_USED}/${ROOT_TOTAL} (${ROOT_USAGE}%)\\nHome: ${HOME_USED}/${HOME_TOTAL} (${HOME_USAGE}%)\", \"class\":\"${CLASS}\", \"percentage\":${USAGE}}"
else
    # Determine icon based on usage
    if [ $ROOT_USAGE -ge 90 ]; then
        ICON=""
        CLASS="critical"
    elif [ $ROOT_USAGE -ge 70 ]; then
        ICON=""
        CLASS="warning"
    else
        ICON=""
        CLASS="normal"
    fi

    echo "{\"text\":\"${ROOT_USED}/${ROOT_TOTAL} ${ICON}\", \"tooltip\":\"Root: ${ROOT_USED}/${ROOT_TOTAL} (${ROOT_USAGE}%)\", \"class\":\"${CLASS}\", \"percentage\":${ROOT_USAGE}}"
fi
