import vagrant
import os
import subprocess

vagrant_dir = os.getcwd()
script_path = os.path.join(vagrant_dir, 'set_up.py')

def create_vagrantfile(directory):
    vagrantfile_content = """
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.provision "shell", inline: <<-SCRIPT
    apt-get update
    apt-get install -y python3
    SCRIPT

  config.vm.provision "file", source: "./set_up.py", destination: "script.py"
end
"""
    with open(os.path.join(directory, 'Vagrantfile'), 'w') as f:
        f.write(vagrantfile_content)

def main():
        
    # Create Vagrantfile
    create_vagrantfile(vagrant_dir)
    
    # Initialize the Vagrant environment
    v = vagrant.Vagrant(vagrant_dir)
    
    # Start up the Vagrant box
    print("Starting up the Vagrant box...")
    v.up()

    # Copy the Python script to the Vagrant box
    print("Copying Python script to the Vagrant box...")
    v.ssh(command="mkdir -p /home/vagrant/scripts")
    v.ssh(command="mv /home/vagrant/script.py /home/vagrant/scripts/")

    # Execute the Python script inside the Vagrant box
    print("Executing Python script inside the Vagrant box...")
    
    v.ssh(command="python3 /home/vagrant/scripts/script.py")

    print("Directories created successfully.")

if __name__ == "__main__":
    main()
