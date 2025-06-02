#!/bin/bash

# 函数：检查是否为闰年
is_leap_year() {
    local year=$1
    if (( (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 )); then
        return 0  # 是闰年
    else
        return 1  # 不是闰年
    fi
}

# 主逻辑
if [ $# -eq 0 ]; then
    echo "错误：请至少输入一个年份参数"
    echo "用法：$0 <年份1> [年份2] ..."
    exit 1
fi

for year in "$@"; do
    # 验证年份格式（4位数字）
    if ! [[ "$year" =~ ^[0-9]{4}$ ]]; then
        echo "错误：无效年份 '$year'，必须为4位数字"
        continue
    fi

    # 创建年份目录
    mkdir -p "$year"
    
    # 检查闰年并设置二月天数
    if is_leap_year "$year"; then
        days_in_month=(31 29 31 30 31 30 31 31 30 31 30 31)
    else
        days_in_month=(31 28 31 30 31 30 31 31 30 31 30 31)
    fi

    # 遍历12个月份
    for month in {1..12}; do
        # 格式化为两位数的月份
        mm=$(printf "%02d" "$month")
        
        # 创建月份目录 (YYYY-MM)
        month_dir="${year}/${year}-${mm}"
        mkdir -p "$month_dir"

        # 获取当前月份的天数
        days=${days_in_month[$((month-1))]}

        # 创建日期目录 (YYYY-MM-DD)
        for day in $(seq -w 1 "$days"); do
            date_dir="${year}-${mm}-${day}"
            mkdir -p "${month_dir}/${date_dir}"
        done
    done

    echo "已生成 $year 年的目录结构"
done