import os
import sys 
import subprocess


dirPath = "/home/vagrant"
companyDirectoryName = "kodecamp-stores"
allowed_directories = ["finance-budgets", "contract-documents", "business-projections", "business-models", "employee-data", "company-vision-and-mission-statement", "server-configuration-script"]

users = {
    "andrew": "system-administrator",
    "julius": "legal",
    "chizi": "human-resource-manager",
    "jeniffer": "sales-manager",
    "adeola": "business-strategist",
    "bach": "ceo",
    "gozie": "it-intern",
    "ogochukwu": "finance-manager"
}


# Function to run a shell command
def run_command(command):
    try:
        subprocess.run(command, check=True, shell=True)
    except subprocess.CalledProcessError as e:
        print(f"An error occurred while running command: {command}\n{e}")

# Create users and assign to groups
def create_user_group(users):
  # Create users and assign to groups
  for username, group in users.items():
    # Create the user
    run_command(f"sudo adduser --disabled-password --gecos '' {username.lower()}")
    
    # Create the group if it doesn't exist
    run_command(f"sudo groupadd -f '{group}'")
    
    # Add the user to the group
    run_command(f"sudo usermod -aG '{group}' {username.lower()}")

  print("Users and groups have been created successfully.")

def chDir():
    os.chdir(companyDirectoryName)

def resource():
    dir = os.getcwd()

    # Is current directory /home/vagrant
    if dir == dirPath: 
        os.mkdir(companyDirectoryName)
        chDir()
    else:
        os.chdir(dirPath)
        os.mkdir(companyDirectoryName)
        chDir()

def create_directories(allowed_directories):
    for directory in allowed_directories:
        try:
            os.makedirs(directory, exist_ok=True)
            print(f"Directory '{directory}' created successfully.")
        except Exception as e:
            print(f"An error occurred while creating directory '{directory}': {e}")

# Create a file in allowed directories
def create_file_in_dir(filename, directory, allowed_directories):
  if directory not in allowed_directories:
    print(f"Directory '{directory}' not allowed. Skipping file creation.")
    return False
  
  # Check if directory exists
  if not os.path.exists(directory):
    print(f"Directory '{directory}' doesn't exist. Skipping file creation.")
    return False

# Create the file
  try:
    with open(os.path.join(directory, filename), 'w') as f:
      f.write("")  # Create an empty file
    print(f"File '{filename}' created in directory '{directory}'.")
    return True
  except OSError as e:
    print(f"Error creating file '{filename}': {e}")
    return False
  
    


def main():
    print("Executing Main Function....")


    create_user_group(users)
    resource()
    create_directories(allowed_directories)

    # Get user input for the file name and directory name
    # file_name = input("Enter the file name: ")
    # directory_name = input("Enter the directory name: ")

    # create_file_in_dir(file_name, directory_name)


if __name__ == "__main__":
    main()