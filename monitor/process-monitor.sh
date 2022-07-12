#!/bin/bash
#把运行超过N小时的服找出来处理
process=PMServer

function show_elapsed_time()
{
 user_hz=$(getconf CLK_TCK) #mostly it's 100 on x86/x86_64
 pid=$1
 jiffies=$(cat /proc/$pid/stat | cut -d" " -f22)
 sys_uptime=$(cat /proc/uptime | cut -d" " -f1)
 last_time=$(( ${sys_uptime%.*} - $jiffies/$user_hz ))
 hours=`expr $last_time / 3600`
 #echo "the process $pid lasts for $last_time seconds. $hours hours"
 echo $hours
}

pids=$(ps -ef | grep $process | grep -v grep | grep -v "ps -ef" | awk '{print $2}')
pids=(${pids// /})
tLen=${#pids[@]}
echo "process num" $tLen
for ((i=0;i<${tLen};i++));
do
  pid=${pids[$i]}
  start_time=$(ps -p $pid -o lstart | awk '{print $2,$3,$4,$5,$6}')
  echo $process $pid ${start_time}
  hours=`show_elapsed_time $pid`
  if [ $hours -gt 3 ]; then
     echo "the $process,pid:$pid have run more than $hours hours,need kill!!!" 	
  fi
done





