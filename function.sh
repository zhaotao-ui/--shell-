#!/bin/bash
echo 
echo 
grepurl=`cat urlfilter`
echo -e "1. 在urlfilter检查要排除的url,目前有\n$grepurl\n"
#touch urlfilter.txt
echo "2. 请注意此脚本是广度优先工作！！！"
# egrep -o "https?://[a-zA-Z0-9\.+\/*]*"
i=3
while (($i >= 0 ))
do
read  -p  "3. 输入一个url和探测层数,空格隔开: " url deep
num=`echo $url | egrep -o "https?://[a-zA-Z0-9\.+\/*]*"`
re=`echo $?`

#判断区
if (($re==1))
then
echo -e "请输入正确url\n"
else
break   #跳出
fi
echo "还有$i次机会"
c=$((i-=1))
done     


#主函数
#-----------------------------------------------------------------------------------------------------------
fun(){
q1="$3?://[a-zA-Z0-9\.+\/*\?=\&\#]*"
reurl=`curl $1 |  egrep -o "$q1" > httpbug.txt `
deep=$2
y=$2
t=$4
while (($deep > 0 ))
do  
#文件url去重

fun1(){
	x=`sed -n '/'"$1"'/!p' httpbug.txt | awk -F"/" '{print $3}'`
	for i in $x
	do
		sed -i '/'"$i"'/'d httpbug.txt
	done
echo "----------------------筛选url中"
wait
echo "----------------------筛选url完成"
}
fun1 "$t"

fun2(){
a=`cat urlfilter`
for i in $a
do
sed -i '/'"$i"'/d' httpbug.txt &
done
wait
}

fun2

cat httpbug.txt | sort | uniq  > rebug1.txt
cat rebug1.txt > httpbug.txt
len=`cat httpbug.txt |wc -l`
con=`cat httpbug.txt`
a2=$((y-(deep-1)))
echo -e "第$a2层遍历\n"
cat  httpbug.txt >> allurl
echo > httpbug.txt
for i in $con
                do

                        echo $i,目前层数$a2
                   curl -m 3 -s $i |  egrep -o "$q1"  >> httpbug.txt  &
                        echo "-----------"
		done
#文件url去重o
echo "---------------------等待进程结束中！！-----------"
wait
echo "---------------------wait进程结束！！-----------"
fun1 "$t"
fun2
cat httpbug.txt | sort | uniq  > rebug1.txt
cat rebug1.txt > httpbug.txt
cat  httpbug.txt >> allurl
deep=$((--deep))
done
}
#----------------------------------------------------------
deep=${deep:-1}
read -p "4. 输入协议，如http，ftp等，默认http或者https"  proto
read -p "只爬哪一个：" del
proto=${proto:-https}
> allurl
fun "$url"  "$deep"   "$proto"  "$del"    
wait

echo "内容存在httpbug.txt"               
echo   $deep 
