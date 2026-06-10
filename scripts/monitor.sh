#!/bin/bash

LOG_DIR="$HOME/QuanLyTienTrinh/logs"
BACKUP_DIR="$HOME/QuanLyTienTrinh/backup"
LOG_FILE="$LOG_DIR/monitor.log"

sleep_process () {
    echo "Các tiến trình sleep: "
    ps aux | grep -E "sleep [0-9]+" | grep -v grep
    if [ $? -ne 0 ]; then
        echo "Không có tiến trình sleep nào."
    fi
}

log_create () {
    echo " -> $(date '+%d-%m-%Y %H-%M')"
    ps aux | grep -E "sleep [0-9]+" | grep -v grep >> "$LOG_FILE"
    echo "Đã ghi log vào $LOG_FILE."
}

kill_process () {
    pids=$(ps aux | grep -E "sleep [0-9]+" | grep -v grep | awk '{print $2}')
    if [ -z "$pids" ]; then
        echo "Không có tiến trình nào để dừng."
        return
    fi
    count=0
    for pid in $pids; do
        kill "$pid" 2>/dev/null && ((count++))
        done
        echo "Đã dừng $count tiến trình sleep."
}

backup_log () {
    if [ ! -f "$LOG_FILE" ]; then
        echo "Chưa tạo file log / File log không tồn tại."
        return
    fi
    time_backup=$(date '+%d-%m-%Y_%H-%M')
    backup_file="$BACKUP_DIR/monitor_$time_backup.tar.gz"
    tar -czf "$backup_file" -C "$LOG_DIR" "monitor.log"
    echo "Đã nén log thành: $backup_file"
}

while true; do

    clear
    echo
    echo " -> Menu quản lý"
    echo
    echo "1. Xem danh sách tiến trình sleep"
    echo "2. Ghi log tiến trình"
    echo "3. Dừng tất cả các tiến trình sleep"
    echo "4. Sao lưu file log"
    echo
    echo "0. Thoát"
    echo
    echo -n "Chọn chức năng: "

    read choice
    case $choice in
        1) sleep_process ;;
        2) log_create ;;
        3) kill_process ;;
        4) backup_log ;;
        0) echo "Thoát chương trình." ;;
        *) echo "Lựa chọn không hợp lệ, nhập từ 0-4." ;;
    esac
    read -p "Nhấn Enter để tiếp tục..."
done
