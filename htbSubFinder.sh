#!/bin/bash

target_ip=
domain=
wordlist=
timeout=4
total_lines=0
current_line=0

cleanup_hosts_file() {
    if [ -n "$full_domain" ]; then
        echo "Removing ${full_domain} from /etc/hosts."
        sed -i "/${full_domain}/d" /etc/hosts
    fi
    exit 1
}

show_help() {
    echo "Usage: sudo bash $0 [options] -i <target_ip> -d <domain> -w <wordlist>"
    echo ""
    echo "Options:"
    echo "  -d, --domain DOMAIN"
    echo "  -i, --ip IP address"
    echo "  -w, --wordlist WORDLIST  Set Wordlist"
    echo "  -t, --timeout TIMEOUT    Set connection timeout (default: 4)"
    echo "  -h, --help               Show this help message and exit"
    echo ""
    exit 0
}

while [ $# -gt 0 ]; do
    case "$1" in
        -t|--timeout)
            timeout=$2
            shift
            ;;
        -i|--ip)
            target_ip=$2
            shift
            ;;
        -d|--domain)
            domain=$2
            shift
            ;;
        -w|--wordlist)
            wordlist=$2
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            break
            ;;
    esac
    shift
done

if [ $# -ne 0 ] || [ -z "$target_ip" ] || [ -z "$domain" ] || [ -z "$wordlist" ]; then
    show_help
fi

total_lines=$(wc -l < $wordlist)

echo ' _  _ _____ ___   ___ _   _ ___ ___ ___ _  _ ___  ___ ___ '
echo '| || |_   _| _ ) / __| | | | _ | __|_ _| \| |   \| __| _ \'
echo '| __ | | | | _ \ \__ | |_| | _ | _| | || .` | |) | _||   /'
echo '|_||_| |_| |___/ |___/\___/|___|_| |___|_|\_|___/|___|_|_\'
echo 'CODED BY PORTSIGN'
echo ''
read -p "Press enter to start scanning..."
trap 'cleanup_hosts_file' INT

while read subdomain; do
    current_line=$((current_line+1))
    full_domain="${subdomain}.${domain}"

    echo -n "Scanning ${full_domain} (${current_line}/${total_lines})      "
    echo -ne "\r"

    echo "${target_ip}    ${full_domain}" >> /etc/hosts
    response=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout ${timeout} -I "http://${full_domain}" 2>/dev/null)
    if [ "$response" == "200" ] || [ "$response" == "302" ]; then
        echo -e "\033[32mFound\033[0m ${full_domain} (HTTP/${response})."
        sed -i "/${full_domain}/d" /etc/hosts
    elif [ "$response" == "" ]; then
        sed -i "/${full_domain}/d" /etc/hosts
        echo "Could not connect to ${full_domain}, removing from /etc/hosts."
    else
        sed -i "/${full_domain}/d" /etc/hosts
    fi
done < $wordlist

echo "Reached end of wordlist, no subdomains found."
exit 1