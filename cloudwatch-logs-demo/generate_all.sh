# Number of messages to generate
num_messages=500

# Get the current timestamp in milliseconds
current_timestamp=$(date +%s%3N)

# Open the JSON array
echo "[" > events_all.json

# Array of possible HTTP response statuses
statuses=(200 400 404 500)

# Generate log messages
for i in $(seq 1 $num_messages); do
  # Format the timestamp and message
  formatted_timestamp=$(date -d @$((current_timestamp + i)) '+%Y-%m-%dT%H:%M:%S.%3N')
  message="User $(($RANDOM % 1000 + 1)) - bob [${formatted_timestamp}] \"GET /file HTTP/1.1\" ${statuses[$RANDOM % ${#statuses[@]}]}"
  
  # Escape special characters in the message
  escaped_message=$(echo $message | sed 's/"/\\"/g')
  
  # Create a JSON object for the log event
  json="{\"timestamp\":\"${formatted_timestamp}\",\"message\":\"${escaped_message}\"}"
  
  # If this is not the first message, append a comma before the JSON object
  if [ $i -gt 1 ]; then
    echo "," >> events_all.json
  fi
  
  # Append the JSON object to the file
  echo $json >> events_all.json
done

# Close the JSON array
echo "]" >> events_all.json
