#!/bin/bash

while true; do
    echo "Chọn chức năng:"
    echo "1. Hiển thị các tiến trình sleep đang chạy."
    echo "2. Lưu danh sách các tiến trình sleep vào file."
    echo "3. Kết thúc tiến trình có thời gian ngủ lớn nhất."
    echo "4. Thoát script."
    echo
    read -p "Nhập lựa chọn của bạn (1-4): " choice
    echo
    case $choice in
        1)
            ps aux | grep 'sleep' | awk '{print $2, $8}'
            pid=$(ps aux | grep 'sleep' | sort -k8 -nr | head -n1 | awk '{print $2}')
            echo "PID của tiến trình có thời gian ngủ lớn nhất: $pid"
            ;;
        2)
            read -p "Bạn muốn lưu output vào file không? (y/n): " save
            if [ "$save" == "y" ]; then
                ps aux | grep 'sleep' > danhsach.txt
                echo "Output đã được lưu vào danh sach.txt"
            else
                echo "Không lưu output."
            fi
            ;;
        3)
            pid=$(ps aux | grep 'sleep' | sort -k8 -nr | head -n1 | awk '{print $2}')
            read -p "Bạn muốn kill tiến trình có thời gian ngủ dài nhất không? (y/n): " kill
            if [ "$kill" == "y" ]; then
                kill $pid
                sleep 2
                ps aux | grep 'sleep' | grep $pid > /dev/null
                if [ $? -ne 0 ]; then
                    echo "Tiến trình đã được kill."
                else
                    echo "Không thể kill tiến trình."
                fi
            else
                echo "Không kill tiến trình."
            fi
            ;;
        4)
            break
            ;;
        *)
            echo "Lựa chọn không hợp lệ. Vui lòng chọn từ 1 đến 4."
            ;;
    esac
    echo
    read -p "Nhấn Enter để tiếp tục..."
    clear
done
