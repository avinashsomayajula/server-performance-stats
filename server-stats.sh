#!/bin/bash
# ==========================================================
# server-stats.sh
# Author: <Your Name>
# Description: Analyze basic Linux server performance stats
# ==========================================================

# Function to print a section header
print_header() {
  echo -e "\n==================== $1 ====================\n"
}

# CPU Usage
print_header "CPU Usage"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " 100 - $8 "%"}'

# Memory Usage
print_header "Memory Usage"
free -h | awk 'NR==2{printf "Used: %s / Total: %s (%.2f%%)\n", $3, $2, $3/$2 * 100.0 }'

# Disk Usage
print_header "Disk Usage"
df -h --total | awk '/total/{printf "Used: %s / Total: %s (%s)\n", $3, $2, $5}'

# Top 5 processes by CPU usage
print_header "Top 5 Processes by CPU"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# Top 5 processes by Memory usage
print_header "Top 5 Processes by Memory"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

# Stretch goals
print_header "Additional System Information"
echo "OS Version: $(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2 | tr -d '\"')"
echo "Uptime: $(uptime -p)"
echo "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
echo "Logged in users: $(who | wc -l)"
echo "Failed login attempts (last 24h):"
sudo journalctl --since "24 hours ago" | grep "Failed password" | wc -l

