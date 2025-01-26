#!/bin/bash

# Function to check container status
check_container() {
    local container=$1
    local status=$(docker inspect -f '{{.State.Status}}' $container 2>/dev/null)
    local health=$(docker inspect -f '{{.State.Health.Status}}' $container 2>/dev/null)
    
    if [ -z "$status" ]; then
        echo "❌ $container is not found"
        return 1
    elif [ "$status" != "running" ]; then
        echo "❌ $container is $status"
        return 1
    elif [ "$health" = "healthy" ] || [ "$health" = "<nil>" ]; then
        echo "✅ $container is running${health:+ and $health}"
        return 0
    else
        echo "⚠️ $container is running but $health"
        return 1
    fi
}

# Function to check URL health
check_url() {
    local url=$1
    local response=$(curl -s -o /dev/null -w "%{http_code}" $url)
    
    if [ "$response" = "200" ] || [ "$response" = "301" ] || [ "$response" = "302" ]; then
        echo "✅ $url is accessible (HTTP $response)"
        return 0
    else
        echo "❌ $url is not accessible (HTTP $response)"
        return 1
    fi
}

# Function to check disk space
check_disk_space() {
    local threshold=90
    local usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [ "$usage" -gt "$threshold" ]; then
        echo "⚠️ Disk usage is high: $usage%"
        return 1
    else
        echo "✅ Disk usage is normal: $usage%"
        return 0
    fi
}

# Function to check backup status
check_backup_status() {
    local backup_dir="backups"
    local latest_backup=$(ls -t $backup_dir/*.json 2>/dev/null | head -n 1)
    
    if [ -z "$latest_backup" ]; then
        echo "❌ No backups found"
        return 1
    fi
    
    local backup_age=$(($(date +%s) - $(date -r "$latest_backup" +%s)))
    local days_old=$((backup_age / 86400))
    
    if [ "$days_old" -gt 1 ]; then
        echo "⚠️ Latest backup is $days_old days old"
        return 1
    else
        echo "✅ Latest backup is less than 1 day old"
        return 0
    fi
}

# Main monitoring checks
echo "=== n8n System Monitor ==="
echo "Time: $(date)"
echo

echo "Container Status:"
check_container "n8n_n8n_1"
check_container "n8n_postgres_1"
check_container "n8n_qdrant_1"
check_container "n8n_nginx_1"
echo

echo "Service Health:"
check_url "https://n8n.sigmaschool.co"
echo

echo "System Status:"
check_disk_space
check_backup_status
echo

# Check SSL certificate expiry
echo "SSL Certificate Status:"
ssl_expiry=$(echo | openssl s_client -servername n8n.sigmaschool.co -connect n8n.sigmaschool.co:443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)
echo "Certificate expires: $ssl_expiry" 