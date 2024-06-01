#!/bin/bash

# Check if Xcode Command Line Tools are installed
if ! command -v xcode-select &> /dev/null; then
    echo "Xcode Command Line Tools are not installed. Installing..."
    xcode-select --install

    # Wait until Xcode Command Line Tools installation completes
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
else
    echo "Xcode CLI tools are already installed."
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing..."
    # Prompt for password and keep it for the duration of the script
    sudo -v

    # Keep sudo alive
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# Install Ansible if not already installed
if ! brew list --formula ansible &>/dev/null; then
    echo "Installing Ansible..."
    brew install ansible
else
    echo "Ansible is already installed."
fi


echo "Continuing to provision with Ansible Script."

#!  Execute the main Ansible playbook
# ansible-playbook -vvv provision.yaml
ansible-playbook provision.yaml

echo "Mac setup complete using Ansible."
