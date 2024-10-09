#!/usr/bin/env bash

# logs=$(< the_log)
logs=$(curl "https://gist.githubusercontent.com/kamranahmedse/e66c3b9ea89a1a030d3b739eeeef22d0/raw/77fb3ac837a73c4f0206e78a236d885590b7ae35/nginx-access.log")

echo "Top 5 IP addresses with the most requests:"
top_five_ip=$(echo "$logs" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 5)
echo "$top_five_ip" | awk '{print $2 " -> " $1 " requests"}' | column --table
printf "\n"

echo "Top 5 most requested paths:"
top_five_path=$(echo "$logs" | awk '{print $7}' | sort | uniq -c | sort -nr | head -n 5)
echo "$top_five_path" | awk '{print $2 " -> " $1 " requests"}' | column --table
printf "\n"

echo "Top 5 response status codes:"
top_five_status_code=$(echo "$logs" | awk '{print $9}' | grep -v '"-"' | sort | uniq -c | sort -nr | head -n 5)
# top_five_status_code=$(echo "$logs" | cut -f 9 -d " " | grep -v '"-"' | sort | uniq -c | sort -nr | head -n 5) -- other way
echo "$top_five_status_code" | awk '{print $2 " -> " $1 " requests"}' | column --table
printf "\n"

echo "Top 5 user agents:"
top_five_user_agents=$(echo "$logs" | cut -f 12- -d " " | sort | uniq -c | sort -nr | head -n 5)
IFS=$'\n'
for line in $(echo "$top_five_user_agents" | awk '{$1=$1};1'); do
  user_agent=$(echo "$line" | awk '{$1="";print}')
  user_agent_count=$(echo "$line" | awk '{print $1 " requests"}')
  print_user_agents+="$user_agent <> $user_agent_count\n"
done
printf "%b" "$print_user_agents" | awk '{$1=$1};1' | column -t -s "<>" 
