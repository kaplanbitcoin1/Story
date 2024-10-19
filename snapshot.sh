#!/bin/bash

# SNAPSHOT Setup Script

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# ASCII Art
echo -e "${CYAN}=====-:. ..                      .     ..                  .  :-:.        .--====${NC}"
echo -e "${CYAN}===:.::..                              .                  ..  .::..      .:-====${NC}"
echo -e "${CYAN}==---:.                .::::::::::--:.      ..:--===----:: ..   ...     ..-=====${NC}"
echo -e "${CYAN}====:               .:=+***########%%##+=-+*##%%%%%%%%##*+:  ..   ..      .:====${NC}"
echo -e "${CYAN}====...            .=+***#######%%%%%%%%%%%%%%%%%%%%%%%##*+.${NC}                ${CYAN} :===" 
echo -e "${CYAN}====:::           .=+***#######%%%%%%%%%%%%%%%%%%%%%%%%%##*+:.${NC}              ..-=${NC}"
echo -e "${CYAN}====--:    .      :+***#######%%%%%%%%%%%%%%%%%%%%%%%%%%%###*=:           . ..:=${NC}"
echo -e "${CYAN}=====-:....      .-+***#######%%%%%%%%%%%%%%%%%%%%%%%%%%%#####*-.          .:::=${NC}"
echo -e "${CYAN}=====-:....      .-+***#######%%%%%%%%%%%%%%%%%%%%%%%%%#%######+:.           :==${NC}"
echo -e "${CYAN}====-. ...       .=***########%%%%%%%%%%%%%%%%%%%%%%%%##%%%#####=.         .-.:=${NC}"
echo -e "${CYAN}===-:=:.. ..   .+%###########%###%%%%%%%%%%%%%%%%%%%#%%%%%######+         :===${NC}"
echo -e "${CYAN}===-==- . .    +%%#########%%%%%%%%%%%#%%#%#%%%%%%%%%%%##%%%%######+      .-.===${NC}"
echo -e "${CYAN}=======:. .   :%%%##*++========+++**##*#%*##*##**++==-----===++*####-     .:--===${NC}"
echo -e "${CYAN}========: .   =%%%#*====++==-:....::-=+##*##+=--:...::-=++***++**###*     .=====${NC}"
echo -e "${CYAN}=========:.   *%%#****++======-----:-=+*####*=::------======++**#####:   -:=====${NC}"
echo -e "${CYAN}=========+=   #%##**+=-..-:... :-:-=--+#%%%%#=-==-:=:....=:.:=+#####%=  =++=====${NC}"
echo -e "${CYAN}=========+==:.#%**###%%%%%%%%%########**#%%%%%##*+*#%%%%%%%%####**##: +=*#*=====${NC}"
echo -e "${CYAN}==========*#*.=%***####%%%%%%%%%%##**#*++*###*+***+###%%%%%%%%####**##: +=*#*=====${NC}"
echo -e "${CYAN}==========*#+-:%#+***###%%%%%%%%##+*%##%%%%%##%#+##%%%%%%%%%%###***#+.-+=*=======${NC}"
echo -e "${CYAN}==========+=-= +%*+***####%%%%%%##+#*++*###*+***+###%%%%%%%%####**##: +=.-=======${NC}"
echo -e "${CYAN}===========:-+ :##****#####%%%%%%%*=-::-+++-::-=*%%%%%%%%%%#######+. .:::=======${NC}"
echo -e "${CYAN}===========::.  =******#####%%%%%%%#*+=======+##%%%%%%%%%%#######*-.   :--======${NC}"
echo -e "${CYAN}===========--:  .+*****#####%%%%%%%%#+--=#=---+#%%%%%%%%%%#######*-.   =========${NC}"
echo -e "${CYAN}=============-   :+***########%#*+++++++*##**+++++=+#%%%%#######*-.   .-========${NC}"
echo -e "${CYAN}=============:.   :+**########+--+*************#**+-:=########*+-... .:-========${NC}"
echo -e "${CYAN}============--:..   .:=++**###%%%%%#+=+*#%%%%%####**+=:  .-+*#*       ..::-=${NC}"
echo -e "${CYAN}=====-::.   .      .**+==:   .:--==+-:-:...::--=+===-..  .-++**####.       ... .${NC}"

# Menu
echo -e "\n${PURPLE}                KAPLAN SNAPSHOT                ${NC}"
echo -e "${GREEN}=== SNAPSHOT Node Setup Menu ===${NC}"
echo -e "${RED}1. Update System and Install Required Packages${NC}"
echo -e "${RED}2. Stop Node Services${NC}"
echo -e "${RED}3. Backup Validator State${NC}"
echo -e "${RED}4. Remove Story Data${NC}"
echo -e "${RED}5. Download Story Snapshot (1.9 GB, Height: 1,568,514)${NC}"
echo -e "${RED}6. Restore Validator State${NC}"
echo -e "${RED}7. Remove Geth Data${NC}"
echo -e "${RED}8. Download Geth Snapshot (50.7 GB, Height: 1,568,514)${NC}"
echo -e "${RED}9. Download Address Book${NC}"
echo -e "${RED}10. Download Genesis File${NC}"
echo -e "${RED}11. Configure Permanent Peers${NC}"
echo -e "${RED}12. Configure Node${NC}"
echo -e "${RED}13. Start Node Services${NC}"
echo -e "${RED}14. Exit${NC}"
echo -e "${GREEN}========================================${NC}"

# Function Definitions
function update_system() {
    echo -e "${GREEN}Updating system and installing required packages...${NC}"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y curl git make build-essential python3-pip
    pip3 install gdown
}

function stop_node_services() {
    echo -e "${GREEN}Stopping node services...${NC}"
    sudo systemctl stop story story-geth
}

function backup_validator_state() {
    echo -e "${GREEN}Backing up the private validator state file...${NC}"
    cp $HOME/.story/story/data/priv_validator_state.json $HOME/.story/story/priv_validator_state.json.backup
}

function remove_story_data() {
    echo -e "${GREEN}Removing old Story data...${NC}"
    rm -rf $HOME/.story/story/data
}

function download_story_snapshot() {
    echo -e "${GREEN}Downloading Story snapshot (1.9 GB, Height: 1,568,514)...${NC}"
    curl http://snapshot-kaplan-story.mooo.com/story_19.10.2024.tar | tar -xf - -C $HOME/.story/story
    echo -e "${GREEN}Loaded size: 1.9 GB, Height: 1,568,514${NC}"
}

function restore_validator_state() {
    echo -e "${GREEN}Restoring the private validator state file from backup...${NC}"
    mv $HOME/.story/story/priv_validator_state.json.backup $HOME/.story/story/data/priv_validator_state.json
}

function remove_geth_data() {
    echo -e "${GREEN}Removing Geth data...${NC}"
    rm -rf $HOME/.story/geth/iliad/geth/chaindata
}

function download_geth_snapshot() {
    echo -e "${GREEN}Downloading Geth snapshot (50.7 GB, Height: 1,568,514)...${NC}"
    curl http://snapshot-kaplan-story.mooo.com/geth_19.10.2024.tar | tar -xf - -C $HOME/.story/geth/iliad/geth
    echo -e "${GREEN}Loaded size: 50.7 GB, Height: 1,568,514${NC}"
}

function download_address_book() {
    echo -e "${GREEN}Downloading address book...${NC}"
    wget 'https://drive.google.com/uc?export=download&id=1ClWv2o3TM4stqC_4BaWLyJ-jLM824_re' -O addrbook.json
}

function download_genesis_file() {
    echo -e "${GREEN}Downloading genesis file...${NC}"
    wget 'https://drive.google.com/uc?export=download&id=1Mzqxf4zEAfdiZr2it66X3Cidq0JhrQ9b' -O genesis.json
}

function configure_permanent_peers() {
    echo -e "${GREEN}Configuring permanent peers...${NC}"
    PEERS="f16c644a6d19798e482edcfe5bd5728a22aa5e0d@62.171.154.179:15600"
    sed -i.bak "s|^persistent_peers =.*|persistent_peers = \"$PEERS\"|" $HOME/.story/story/config/config.toml
}

function configure_node() {
    echo -e "${GREEN}Configuring node...${NC}"
    sed -i.bak "s|^moniker =.*|moniker = \"kaplan\"|" $HOME/.story/story/config/config.toml
    sed -i.bak "s|^chain_id =.*|chain_id = \"story-testnet\"|" $HOME/.story/story/config/config.toml
}

function start_node_services() {
    echo -e "${GREEN}Starting node services...${NC}"
    sudo systemctl start story story-geth
}

# Menu Loop
while true; do
    read -p "Select an option [1-14]: " option
    case $option in
        1) update_system ;;
        2) stop_node_services ;;
        3) backup_validator_state ;;
        4) remove_story_data ;;
        5) download_story_snapshot ;;
        6) restore_validator_state ;;
        7) remove_geth_data ;;
        8) download_geth_snapshot ;;
        9) download_address_book ;;
        10) download_genesis_file ;;
        11) configure_permanent_peers ;;
        12) configure_node ;;
        13) start_node_services ;;
        14) exit 0 ;;
        *) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
    esac
done
