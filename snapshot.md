<img width="646" alt="KaplanStorySnapshot" src="https://github.com/user-attachments/assets/dd223d4b-305f-4a34-8c75-ef64e3497b98">

```
bash <(curl -s https://raw.githubusercontent.com/kaplanbitcoin1/Story/main/snapshot.sh)
```

Snapshot Setup Script Explanation
Update System and Install Required Packages: Updates the package list and installs necessary tools like curl, git, make, build-essential, and python3-pip to ensure your system is ready for the snapshot setup.

Stop Node Services: Stops the currently running Story and Geth node services to prevent data corruption during the update process.

Backup Validator State: Backs up the private validator state file, allowing for restoration of the validator's state if needed after the snapshot update.

Remove Old Data and Extract Snapshot: Deletes old Story data and downloads the latest snapshot from the specified URL, ensuring a fresh state for the node.

Restore Validator State: Restores the validator's private state from the backup created in step 3, allowing the validator to resume its operations without losing its state.

Remove Geth Data and Extract Snapshot: Deletes old Geth data and downloads the latest Geth snapshot from the specified URL to keep the Geth node synchronized with the network.

Download Address Book: Retrieves the latest address book for the Story node, which contains the peer information necessary for connecting to the network.

Download Genesis File: Downloads the latest genesis file, which is essential for initializing the node and ensuring it recognizes the blockchain's history.

Configure Permanent Peers: Configures the node to connect to specific permanent peers, helping maintain a stable connection to the network.

Configure Node: Downloads the address book and genesis file while setting up the permanent peers, streamlining the configuration process for the Story node.

Start Node Services: Restarts the Story and Geth services, allowing the node to operate with the newly updated data and configurations.

Exit Script: Exits the menu, terminating the script once the user has completed all desired operations.

Invalid Option Handling: Provides feedback for any invalid menu selections, guiding the user to select a valid option from the menu.

Completion Message: Displays a message upon the successful execution of all operations, confirming that the snapshot setup is complete.

