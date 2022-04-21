#!/bin/bash

echo "****************************************************"
echo "             시스템 취약점 점검을 실시합니다.         "
echo "****************************************************"
echo "시작 시간 : $(date)"
echo ""

passwd=$(ls -al /etc/passwd | cut -c 1-10)
echo "01. /etc/passwd 파일 권한 점검"
if [ $(ls -al /etc/passwd | cut -c 8-10) == "r--" ]; then
    echo "  ===> [양호] 현재 권한 : $passwd"
else
    echo "  ===> [취약] 현재 권한 : $passwd"
fi

echo ""
echo "02. 라우팅 기능 활성화 여부 점검"
if [ $(cat /proc/sys/net/ipv4/ip_forward) == "0" ]; then
    echo "  ===> [양호] 라우팅 기능이 비활성화 되어 있습니다."
else
    echo "  ===> [취약] 라우팅 기능이 활성화 되었습니다."
fi

echo ""
echo "03. SetUID, SetGID, Sticky bit 파일을 검색하여 저장합니다. 저장 위치는 /root/flist.txt 입니다."
find / -type f -perm -o+t 2>/dev/null > /root/flist.txt
find / -type f -perm -u+s 2>/dev/null >> /root/flist.txt
find / -type f -perm -g+s 2>/dev/null >> /root/flist.txt