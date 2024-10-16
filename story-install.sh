#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "\e[31mPlease run as root\e[0m"
    exit 1
fi

# Function to install dependencies
install_dependencies() {
    echo "Installing dependencies..."
    apt update && apt upgrade -y
    apt install -y curl git make build-essential figlet
    if ! command -v gdown &> /dev/null; then
        echo "gdown not found, installing..."
        apt install -y python3-pip
        pip3 install gdown
    fi
    echo "Dependencies installed successfully 🐅"
}

# Function to install Go
install_go() {
    echo "Installing the latest version of Go..."
    wget https://golang.org/dl/go1.23.1.linux-amd64.tar.gz
    tar -C /usr/local -xzf go1.23.1.linux-amd64.tar.gz
    rm go1.23.1.linux-amd64.tar.gz
    echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bash_profile
    source ~/.bash_profile
    echo "Go installation completed."
}

# Function to install Cosmovisor
install_cosmovisor() {
    echo "Installing Cosmovisor..."
    go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.6.0
    echo "Cosmovisor installed successfully."
}

# Print KAPLAN in ASCII art
print_logo() {
    if command -v figlet &> /dev/null; then
        echo -e "\e[33m"  # Set text color to orange
        figlet -f slant "KAPLAN"
        echo -e "\e[0m"   # Reset text color
    else
        echo "Figlet is not installed. Installing figlet..."
        apt install -y figlet
        print_logo  # Call print_logo again after installing
    fi
}

# Download file from Google Drive
download_file() {
    file_id=$1
    file_name=$2
    confirm=$(wget --quiet --save-cookies cookies.txt --keep-session-cookies --no-check-certificate "https://drive.google.com/uc?id=${file_id}" -O- | \
    sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p')
    wget --load-cookies cookies.txt "https://drive.google.com/uc?export=download&confirm=${confirm}&id=${file_id}" -O "${file_name}"
    rm cookies.txt
    echo "${file_name} downloaded successfully."
}

# Download and install Story-Geth binary
install_geth_binary() {
    echo "Downloading Story-Geth binary..."
    download_file "1e3z4vcB3YCZ_qPNv5pLmiNXTOGtUZtad" "/usr/local/bin/story-geth"
    chmod +x /usr/local/bin/story-geth
    echo "Story-Geth binary installed successfully 🐅"
}

# Download and install Story binary using gdown
install_story_binary() {
    echo "Downloading Story binary..."
    gdown "https://drive.google.com/uc?id=1oiTZZj-jyph02wDh48JLDQVYXVrryrI_" -O "/usr/local/bin/story"
    chmod +x /usr/local/bin/story
    echo "Story binary installed successfully 🐅"
}

# Initialize node with custom moniker
init_node() {
    /usr/local/bin/story init --network iliad --moniker "$moniker"
    echo "Node initialized with moniker: $moniker."
}

# Create systemd service files
create_service_files() {
    echo "Creating service files..."
    
    sudo tee /etc/systemd/system/story-geth.service > /dev/null <<EOF
[Unit]
Description=Story Geth Client
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/story-geth --iliad --syncmode full
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    sudo tee /etc/systemd/system/story.service > /dev/null <<EOF
[Unit]
Description=Story Consensus Client
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/story run
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
    echo "Service files created successfully 🐅"
}

# Start services
start_services() {
    echo "Starting services..."
    sudo systemctl daemon-reload
    sudo systemctl enable story-geth --now
    sudo systemctl enable story --now
    echo "Services started successfully 🐅"
}

# Function to check service status for both Story and Story-Geth
check_status() {
    echo "Checking service status..."
    echo -e "\n\e[36m● story-geth.service - Story Geth Client\e[0m"
    systemctl status story-geth --no-pager

    echo -e "\n\e[36m● story.service - Story Consensus Client\e[0m"
    systemctl status story --no-pager
}

# Function to show logs for Story or Story-Geth
show_logs() {
    echo -e "\e[33mWhich logs would you like to see?\e[0m"
    echo -e "\e[36m1) Story Geth Logs\e[0m"
    echo -e "\e[36m2) Story Logs\e[0m"
    read -p "Select an option (1 or 2): " log_option

    case $log_option in
        1) 
            echo -e "\n\e[36m=== Story Geth Logs ===\e[0m"
            journalctl -u story-geth --no-pager
            ;;
        2)
            echo -e "\n\e[36m=== Story Logs ===\e[0m"
            journalctl -u story --no-pager
            ;;
        *)
            echo -e "\e[31mInvalid option. Please try again.\e[0m"
            ;;
    esac
}

# Stop services
stop_services() {
    echo "Stopping services..."
    sudo systemctl stop story-geth
    sudo systemctl stop story
    echo "Services stopped successfully 🐅"
}

# Restart services
restart_services() {
    echo "Restarting services..."
    sudo systemctl restart story-geth
    sudo systemctl restart story
    echo "Services restarted successfully 🐅"
}

# Update node
update_story_node() {
    echo "Updating Story Node..."
    
    # Download new binaries
    install_geth_binary
    install_story_binary
    
    # Restart services to apply updates
    echo "Restarting services..."
    sudo systemctl restart story-geth
    sudo systemctl restart story
    echo "✅ Story Node updated successfully!"
}

# Install Story Node
install_story_node() {
    install_dependencies
    print_logo
    read -p "Enter your moniker name: " moniker
    install_geth_binary
    install_story_binary
    init_node
    create_service_files
    start_services
    echo "✅ Story node installation completed!"
}

# Function to change ports in config.toml
change_ports() {
    CONFIG_PATH="$HOME/.story/story/config/config.toml"

    if [ ! -f "$CONFIG_PATH" ]; then
        echo -e "\e[31mError: config.toml not found at $CONFIG_PATH\e[0m"
        exit 1
    fi

    read -p "Enter new P2P port (default 26656): " new_p2p_port
    read -p "Enter new RPC port (default 26657): " new_rpc_port
    read -p "Enter new GRPC port (default 9090): " new_grpc_port

    sed -i "s/^laddr = \"tcp:\/\/0.0.0.0:[0-9]*\"/laddr = \"tcp:\/\/0.0.0.0:$new_rpc_port\"/" "$CONFIG_PATH"
    sed -i "s/^p2p\.laddr = \"tcp:\/\/0.0.0.0:[0-9]*\"/p2p\.laddr = \"tcp:\/\/0.0.0.0:$new_p2p_port\"/" "$CONFIG_PATH"
    sed -i "s/^grpc\.address = \"0.0.0.0:[0-9]*\"/grpc\.address = \"0.0.0.0:$new_grpc_port\"/" "$CONFIG_PATH"

    echo -e "\e[32mPorts updated successfully in config.toml\e[0m"
}

# Function to delete Story Node and its services
delete_story_node() {
    echo "Deleting Story Node and its services..."
    
    # Stop and disable services
    sudo systemctl stop story-geth
    sudo systemctl disable story-geth
    sudo systemctl stop story
    sudo systemctl disable story
    
    # Remove binaries
    sudo rm -f /usr/local/bin/story-geth
    sudo rm -f /usr/local/bin/story
    
    # Remove service files
    sudo rm -f /etc/systemd/system/story-geth.service
    sudo rm -f /etc/systemd/system/story.service
    sudo systemctl daemon-reload
    
    # Remove configuration files
    rm -rf $HOME/.story

    echo "✅ Story Node deleted successfully!"
}

# Function to print menu
print_menu() {
    echo -e "\e[36m=======================================\e[0m"
    echo -e "\e[33m|  🐅  WELCOME TO KAPLAN NODE SETUP!  🐅  \e[0m"
    echo -e "\e[36m=======================================\e[0m"
    echo -e "\e[33m|   1) 🛠️  INSTALL STORY NODE         \e[0m"
    echo -e "\e[33m|   2) 🔄  UPDATE STORY NODE          \e[0m"
    echo -e "\e[33m|   3) 🚦  CHECK SERVICE STATUS       \e[0m"
    echo -e "\e[33m|   4) 📜  SHOW LOGS                  \e[0m"
    echo -e "\e[33m|   5) 🛑  STOP SERVICES              \e[0m"
    echo -e "\e[33m|   6) 🔄  RESTART SERVICES           \e[0m"
    echo -e "\e[33m|   7) 🪛  CHANGE PORTS               \e[0m"
    echo -e "\e[33m|   8) 💣  DELETE STORY NODE          \e[0m"
    echo -e "\e[33m|   0) ❌  EXIT                       \e[0m"
    echo -e "\e[36m=======================================\e[0m"
    echo -e "\e[36mFor more information, visit:\e[0m"
    echo -e "\e[32mTelegram: \e[34mhttps://t.me/tigernode\e[0m" 
    echo -e "\e[32mGitHub: \e[34mhttps://github.com/kaplanbitcoin1\e[0m"
}

# Main loop
while true; do
    print_menu
    read -p "Select an option (0-8): " option

    case $option in
        1) install_story_node ;;
        2) update_story_node ;;
        3) check_status ;;
        4) show_logs ;;
        5) stop_services ;;
        6) restart_services ;;
        7) change_ports ;;
        8) delete_story_node ;;
        0) exit 0 ;;
        *) echo -e "\e[31mInvalid option. Please try again.\e[0m" ;;
    esac
done
