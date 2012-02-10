#!/bin/bash

AUTHOR=hernad@bring.out
VER=0.9.9
DATE=10.02.2012

echo $AUTHOR,  $VER, $DATE


USER=bringout
EXE_PATH="C:\\Program Files\\Datecs Applications\\FPrint WIN\\FPrint.exe"
PATH=/usr/bin:/usr/sbin:/bin:/usr/local/sbin:/usr/local/bin


usage () 
{
  echo usage: $0 start ili stop
}


start () {


echo rm logs
rm /tmp/Xvfb_101.log
rm /tmp/FPrint_wine.log

echo start XvFb
export DISPLAY=:101  
echo run: su - $USER -c 'Xvfb :101 -ac &'
su - $USER -c "Xvfb :101 -ac &> /tmp/Xvfb_101.log&"
echo run: sleep 5
sleep 5
echo run: su - $USER -c "wine '$EXE_PATH'"
su - $USER -c "wine '$EXE_PATH' &> /tmp/FPrint_wine.log&" > /dev/null

}

stop () {

echo ubijam sve Xvfb procese i njihove aplikacije
killall wine
killall Xvfb

CNT=`ps ax | grep "FPrint" | grep -c -v "grep"`

if [ $CNT -eq 0 ]
then
  echo "uspjesno ubijen Xvfb ... bye ..."
  exit 0
else
  echo "CNT proces Xvfb = $CNT ?!"
  exit -1
fi

}

status() {

echo "status:"
echo "--------------------"

ps ax | grep "Xvfb" | grep -v "grep"
ps ax | grep "FPrint" | grep  -v "grep"


let CNT=`ps ax | grep "Xvfb" | grep -c -v "grep"`
let CNT=CNT+`ps ax | grep "FPrint" | grep  -c -v "grep"`

if [ $CNT -eq 2 ]
then
  echo "FPrint wine app status OK"
  exit 0
else
  echo "FPrint not started !"
  exit -1
fi


}

if [ "$1" == "" ]
then
    usage
    exit -1
fi


case "$1" in

   start )
        start  
        ;;

   stop )

       stop 
       ;;
   
   status )

      status 
      ;;

esac
