#!/bin/bash

# Get a list of all user logins
user_logins=$(wp user list --field=user_login)

# Check if WP-CLI command executed successfully
if [ $? -ne 0 ]; then
    echo "Error executing WP-CLI command. Please ensure WP-CLI is installed and working correctly."
    exit 1
fi

# Create a new file or overwrite an existing one
echo "" > users_passwords.txt

# Check if file was created successfully
if [ $? -ne 0 ]; then
    echo "Error creating file. Please check your permissions."
    exit 1
fi

# Loop over each user login
for login in $user_logins
do
  # Generate a random password using PHP
  password=$(php -r 'echo substr(str_shuffle("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()"), 0, 20);')

  # Check if password was generated successfully
  if [ $? -ne 0 ]; then
      echo "Error generating password for user $login. Skipping to next user."
      continue
  fi

  # Update the user's password
  wp user update $login --user_pass=$password

  # Check if password was updated successfully
  if [ $? -ne 0 ]; then
      echo "Error updating password for user $login. Skipping to next user."
      continue
  fi

  # Write the user login and new password to the file in the desired format
  echo -e "username: $login\npassword: $password\n\n" >> users_passwords.txt

  # Check if writing to file was successful
  if [ $? -ne 0 ]; then
      echo "Error writing to file. Please check your permissions."
      exit 1
  fi
done
