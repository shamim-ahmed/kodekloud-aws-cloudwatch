#!/bin/bash

# Number of messages to generate
num_messages=500

# Get the current timestamp in milliseconds
current_timestamp=$(date +%s%3N)

# Array of possible HTTP response statuses
statuses=(200 400 404 500)

# Generate log messages and store them in an array
log_events=()
for i in $(seq 1 $num_messages); do
  # Generate a random offset within 12 hours (12 * 60 * 60 * 1000 milliseconds)
  offset=$((RANDOM % (12 * 60 * 60 * 1000)))
  timestamp=$((current_timestamp - offset)) # Subtract offset from the current timestamp

  # Format the timestamp and message
  formatted_timestamp=$(date -d @$((timestamp / 1000)) '+%Y-%m-%dT%H:%M:%S.%3N')
  message="User $(($RANDOM % 1000 + 1)) - bob [${formatted_timestamp}] \"GET /file HTTP/1.1\" ${statuses[$RANDOM % ${#statuses[@]}]}"

  # Escape special characters in the message
  escaped_message=$(echo $message | sed 's/"/\\"/g')

  # Create a JSON object for the log event
  json="{\"timestamp\":${timestamp},\"message\":\"${escaped_message}\"}"

  # Add the JSON object to the log events array
  log_events+=("$json")
done

# Sort the log events by their timestamp
IFS=$'\n' sorted_log_events=($(sort -t: -k2 -n <<<"${log_events[*]}"))
unset IFS

# Open the JSON array
echo "[" > events_all.json

# Write the sorted log events to the JSON file
for i in "${!sorted_log_events[@]}"; do
  # If this is not the first message, append a comma before the JSON object
  if [ $i -gt 0 ]; then
    echo "," >> events_all.json
  fi

  # Append the JSON object to the file
  echo "${sorted_log_events[$i]}" >> events_all.json
done

# Close the JSON array
echo "]" >> events_all.json
