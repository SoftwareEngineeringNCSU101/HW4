#!/bin/bash

# Initialize total age and count
total_age=0
count=0

# Step 1: Preprocess the CSV to handle commas inside quotes (especially in the Name field)
sed -E 's/(\"[^\"]*),(.*\")/\1;\2/' titanic.csv > titanic_preprocessed.csv

# Step 2: Process the preprocessed file
while IFS=',' read -r PassengerId Survived Pclass Name Sex Age SibSp Parch Ticket Fare Cabin Embarked; do
  # Task 1: Filter for passengers in 2nd class and Embarked at Southampton
  if [[ "$Pclass" == "2" && "$Embarked" == "S" ]]; then
    
    # Task 2: Replace male/female with M/F
    if [[ "$Sex" == "male" ]]; then
      Sex="M"
    elif [[ "$Sex" == "female" ]]; then
      Sex="F"
    fi

    # Ensure that the correct number of fields are being processed
    if [[ ! -z "$Age" && "$Age" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
      # Print the filtered data (PassengerId, Pclass, Name, Sex, Age)
      echo "$PassengerId $Pclass \"$Name\" $Sex $Age"

      # Task 3: Collect ages (ignoring empty Age fields)
      total_age=$(echo "$total_age + $Age" | bc)
      count=$((count + 1))
    fi
  fi
done < titanic_preprocessed.csv > task3_filtered_passengers.csv

# Step 4: Calculate average age
if [ $count -gt 0 ]; then
  average_age=$(echo "scale=2; $total_age / $count" | bc)
  echo "Average age of 2nd class passengers who embarked at Southampton: $average_age"
else
  echo "No valid age data found."
fi

# Indicate where the filtered passenger data is stored
echo "Filtered passengers with replaced gender labels have been saved to task3_filtered_passengers.csv."

