#!/bin/bash

STR=""
FLAG=0

# backup을 이미 했다면
if test -f "/backup/list"; then
				# 기존의 파일인지 확인하고, 변경됐거나 새로운 파일이라면 추가하는 코드
        ls -l /var/log | while read line;
        do
                FLAG=0
                while read file;
                do
                        if [ "$line" == "$file" ]; then
                                FLAG=1
                                break
                        fi
                done < /backup/list

                if [ $FLAG == 0 ]; then
                        echo ${line} >> /backup/save
                fi
        done

				# save파일이 있다면
        if test -f "/backup/save"; then
                while read line;
                do
                        read -a t <<< $line # line을 t라는 변수에 저장
                        STR+="/var/log/${t[-1]} " # 새로운 파일을 STR에 저장, 그리고 띄어쓰기 있음
                done < /backup/save
                rm -rf /backup/save
         fi
        tar -cpzf /backup/$(date "+%Y-%m-%d-%H:%M:%S")-log.tar.gz --wildcards $STR 2>/dev/null # STR 파일들만 압축시켜 주겠다
        ls -l /var/log > /backup/list

# backup을 안했다면 backup
else
        tar -cpzf /backup/$(date "+%Y-%m-%d-%H:%M:%S")-log.tar.gz --one-file-system /var/log 2>/dev/null
        ls -l /var/log > /backup/list
fi