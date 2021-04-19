#!/bin/bash
#
## Auto Pull up the script
## ver 2.0
#
_OPT=$1
source ~/.bashrc
ulimit -c unlimited

## define dir
SaScriptsDir=/export/scripts/sa ##scripts dir
_GameServerDir=/data/gameserver ##gameserver dir
_MailTo="test@163.com"          ##Custom Mail To
_ServerConfig=start_group
_MonServerConfig=".start_group"
_ServerGroup=${_GameServerDir}/.group_dir
_tmpMail="/tmp/mon_Server.tmp.txt"
_SmsTo="/data/gameserver/scripts/sms/sendSms.sh"
_CMD=""
[ -f ${SaScriptsDir}/xysms ] && XYSMS=${SaScriptsDir}/xysms || XYSMS=${SaScriptsDir}/tx_xysms

## get IP address  : $HOST
INTERFACE=$(/sbin/ip route | awk '/default via/{print $NF}')
if [[ -z "$INTERFACE" ]]; then
  HOST="$(hostname)-$(/sbin/ifconfig | awk '/192\.|172\.|10\./{gsub("inet addr:","");print $1}' | awk 'NR==1')"
elif [[ -n $(/sbin/ifconfig $INTERFACE >/dev/null 2>&1 || echo 1) ]]; then
  HOST="$(hostname)-$(/sbin/ifconfig | awk '/192\.|172\.|10\./{gsub("inet addr:","");print $1}' | awk 'NR==1')"
else
  Addr=$(/sbin/ifconfig $INTERFACE | awk '/inet addr:/{gsub("addr:","");print $2}')
  if [[ $(echo "$Addr" | awk -F'.' '{print $1}') == "10" ]] || [[ $(echo "$Addr" | awk -F'.' '{print $1}') == "192" ]] || [[ $(echo "$Addr" | awk -F'.' '{print $1}') == "172" ]]; then
    HOST="$(hostname)-${Addr}"
  else
    HOST="$Addr"
  fi
fi

function SendData() {
  /bin/sh ${XYSMS} "$@" >/dev/null 2>&1
}

#### Config
function FUN_Config() {
  find ${_GameServerDir} -type f -name "${_ServerConfig}" >${_ServerGroup}
  for _dir in $(cat ${_ServerGroup}); do
    cd ${_dir%/*}
    awk '!/^$/ && !/^#/{print }' ${_ServerConfig} | awk -F"=" '$1=="group1" || $1=="group2" || $1=="group3" || $1=="group4" {gsub(/ +/," ");gsub(/ $/,"");print $2}' >${_MonServerConfig}
  done
}

function FUN_Status() {
  RUNNING_PID=0
  _scmd=$(echo ${_CMD} | sed -e 's/&$//' -e '/ $/s///g')
  _PID=$(ps -ef | grep "${_scmd}" | grep -v "grep" | awk '{print $2}')
  if [ "${_PID}" != "" ]; then
    _PID_CHECK=$(ps -p ${_PID} -o pid=)
    if [ "${_PID_CHECK}" != "" ]; then
      RUNNING_PID=${_PID}
      return 0 # running
    else
      return 1 # stopped
    fi
  fi
  return 3 # stopped
}

#### CheckUpServer
function FUN_CheckServer() {
  >${_tmpMail}
  for _dir in $(cat ${_ServerGroup}); do
    cd ${_dir%/*}
    _num=$(awk 'END{print NR}' ${_MonServerConfig})
    for ((i = 1; i <= ${_num}; i++)); do
      _CMD=$(awk '!/^#/ && NF && NR=="'$i'" {gsub(/^[ \t]+|[ \t]+$/,"");print}' ${_MonServerConfig})
      if [ "${_CMD}" != "" ]; then
        FUN_Status
        if [ $? -ne 0 ]; then
          echo "start:\t${_CMD}"
          ${_CMD}
          sleep 2
          find . -perm 600 -type f -name "core.[0-9]*" | grep "core.[0-9]*" >/dev/null
          if [ $? -eq 0 ]; then
            find . -perm 600 -type f -name "core.[0-9]*" | xargs chmod 666
          fi

          _server=$(echo "${_CMD}" | awk '{print $1}')
          _port=$(echo "${_CMD}" | sed -n '/^[^#]/s/\([^-p].*\)-p \([1-9][0-9]\{2,\}\)\(.*\)/\2/p')

          FUN_Status
          if [ $? -ne 0 ]; then
            echo -e "HOST:\t${HOST}\nTIME:\t$(date +%Y%m%d_%H:%M)\nDir:\t$(pwd)\nServer/Port:\t$_server $_port core\nStatus:\tStart failed\n\n" >>${_tmpMail}
          else
            echo -e "HOST:\t${HOST}\nTIME:\t$(date +%Y%m%d_%H:%M)\nDir:\t$(pwd)\nServer/Port:\t$_server $_port core\nStatus:\tStart success\n\n" >>${_tmpMail}
          fi
        fi
      fi
    done
  done

  logName=start_$(date +%Y%m%d%H%M)
  if [ ! -z "$(cat ${_tmpMail})" ]; then
    cat ${_tmpMail} >>/data/gameserver/scripts/${logName}.log
    sh ${_SmsTo} ${_tmpMail}
    python /data/gameserver/scripts/monitor.py "游戏服务器重启，如非人工操作请查看重启日志"
  fi
  rm -rf ${_tmpMail}
}

######-------------------------------------------------------------------------------------------
if [[ ${_OPT} == "config" ]]; then
  FUN_Config
  exit
fi

FUN_CheckServer
########end script ###################
