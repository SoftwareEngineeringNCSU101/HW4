#!/bin/bash

# Initialize total age and count
total_age=0
count=0

# Extract passengers from 2nd class who embarked at Southampton
grep ",2," titanic.csv | grep ",S$" | sed -E 's/\bmale\b/M/g; s/\bfemale\b/F/g' | while IFS=',' read -r PassengerId Survived Pclass Name Sex Age SibSp Parch Ticket Fare Cabin Embarked; do
  # Trim leading/trailing spaces and ensure proper quoting for the name
  Name=$(echo "$Name" | sed 's/^"\(.*\)"$/\1/; s/^ //; s/ $//')

  # Ensure that the correct number of fields are being processed
  if [[ ! -z "$Age" && "$Age" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    # Print the filtered data (PassengerId, Pclass, Name, Sex, Age)
    echo "$PassengerId $Pclass \"$Name\" $Sex $Age"
  
    # Collect ages (ignoring empty Age fields)
    total_age=$(echo "$total_age + $Age" | bc)
    count=$((count + 1))
  fi
done

# Calculate average age
if [ $count -gt 0 ]; then
  average_age=$(echo "scale=2; $total_age / $count" | bc)
  echo "Average age: $average_age"
else
  echo "No valid age data found."
fi

