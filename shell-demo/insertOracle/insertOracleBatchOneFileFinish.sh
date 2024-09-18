#!/bin/bash

# 这个脚本需要调试
#
sysPassword='sys'
datebaseName='datebaseNmae'

# 输入数据文件
input_file="data.txt"

# 输出数据文件
output_file="output.sql"

head="true"

# 表头和数据分割
headSplit="======================="

# 存放数据的数组
headArray=()
# 存放col的str
headStr=''
# 要插入的表名
tableName='tableName'

counter=0
batch_size=1000
batch_counter=0

# 读取输入数据
while read -r line; do

    if [ "$head" == "true" ]; then
        # 处理头分隔记录
        if [ "$line" == "$headSplit" ]; then
			headStr=${headStr::-1}
            head="false"
        else
            # 拆分头格式
			key=$(echo $line | awk -F '=' '{print $1 }')
			headStr+=${key}','

            value=$(echo $line | awk -F '=' '{print $2 }')
            headArray[$counter]=$value
        fi
    else
        # 处理数据
        # 分割数据
        IFS="|" read -ra fields <<< "$line"

        # 生成插入语句
        insert_stmt='INSERT INTO '${tableName}'('${headStr}') VALUES ('

        # 遍历字段并将其添加到插入语句中
        for ((i=0; i<${#headArray[@]}; i++)); do
            insert_stmt+="'${fields[i]}',"
        done

        # 删除最后一个逗号
        insert_stmt=${insert_stmt::-1}

        # 添加结束括号
        insert_stmt+="),"

        # 根据 batch_counter 判断是否需要写入新的文件
        if [ $batch_counter -eq 0 ]; then
            echo "BEGIN" > $output_file
            echo "  INSERT ALL" >> $output_file
        fi

        echo "    $insert_stmt" >> $output_file

        batch_counter=$((batch_counter + 1))

        if [ $batch_counter -eq $batch_size ]; then
            echo "  SELECT 1 FROM DUAL;" >> $output_file
            echo "END;" >> $output_file
            batch_counter=0
            batch_size=1000
            ((batch_size++))
        fi

    fi
    counter=$((counter + 1))

done < "$input_file"

# 如果还有剩余的未写入的 SQL，写入到文件中
if [ $batch_counter -gt 0 ]; then
    echo "  SELECT 1 FROM DUAL;" >> $output_file
    echo "END;" >> $output_file
fi

# 使用 SQLPlus 执行生成的 SQL 文件
sqlplus sys/${sysPassword}@${datebaseNmae} as sysdba @${output_file}
