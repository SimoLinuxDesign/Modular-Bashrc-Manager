# Modular Bashrc Manager
### A simple, modular, and clean way to manage your .bashrc file in Linux.
---

This project provides a modular system for managing Bash scripts within the .bashrc environment. It allows users to easily enable, disable, create, and manage custom scripts through a well-structured directory layout, making the .bashrc configuration cleaner and easier to maintain.

## Features

- **Modular Setup**: Keep your .bashrc organized by loading only necessary scripts at runtime.
- **Script Management**: Easily create, enable, disable, and manage scripts through a simple command interface.
- **Automatic Directory Structure**: The installer automatically creates directories for managing available, enabled, removed, and required scripts.
- **Customizable Script Templates**: When creating a new script, a template with placeholders for options, variables, functions, and execution logic is provided.
- **Easy Integration**: Automatically integrate with your existing .bashrc setup.

## Directory Structure

After installation, the system uses the following directory layout to manage scripts:

- `~/.bashrc.d/`: Main directory for managing Bash scripts.
  - `installer/`: Contains the installer and base script.
    - `brc-script-install.sh`
    - `brc-script.sh`
  - `scripts-available/`: Scripts available to be enabled.
  - `scripts-enabled/`: Symbolic links to enabled scripts.
  - `scripts-needed/`: Essential scripts required for the system to work.
    - `brc-script.sh`
  - `scripts-removed/`: Backup of removed scripts, timestamped.

## Installation

### Automated Installation

To install the system automatically, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/your-repo/modular-bashrc-manager.git
    cd modular-bashrc-manager/installer
    ```

2. Make the installer executable and run it:
    ```bash
    chmod +x brc-script-install.sh
    ./brc-script-install.sh
    ```

The installer will:
- Create the necessary directory structure: `scripts-needed`, `scripts-enabled`, `scripts-available`, and `scripts-removed`.
- Append the required configuration to your .bashrc file.
- Copy the main `brc-script.sh` script to `scripts-needed/`.

After the installation completes, restart your shell or reload the .bashrc file by running:
```bash
source ~/.bashrc
```  
### Manual Installation

If you prefer a manual installation process, follow these steps:

1. Copy the `brc-script.sh` file to the `~/.bashrc.d/scripts-needed/` folder:
    ```bash
    cp brc-script.sh ~/.bashrc.d/scripts-needed/
    chmod 750 ~/.bashrc.d/scripts-needed/brc-script.sh
    ```

2. Append the following lines to your `.bashrc` file:
    ```bash
    # Modular Bashrc
    if [ -d ~/.bashrc.d ]; then
        for needed in ~/.bashrc.d/scripts-needed/*.sh; do
            [ -r "$needed" ] && source "$needed"
        done
        unset needed
        for file in ~/.bashrc.d/scripts-enabled/*.sh; do
            [ -r "$file" ] && source "$file"
        done
        unset file
    fi
    ```

3. Create the necessary directories:
    ```bash
    mkdir -p ~/.bashrc.d/scripts-needed ~/.bashrc.d/scripts-enabled ~/.bashrc.d/scripts-available ~/.bashrc.d/scripts-removed
    ```

4. Restart your shell or source `.bashrc`:
    ```bash
    source ~/.bashrc
    ```

## Usage

The `brc-script.sh` script provides a series of commands to manage your .bashrc scripts:

- `-c` : Create a new script in the `scripts-available/` folder.
- `-m` : Modify an existing script.
- `-l` : List all available and enabled scripts.
- `-e <index>` : Enable a script from the `scripts-available/` folder.
- `-d <index>` : Disable an enabled script.
- `-r <index>` : Remove a script, backing it up in `scripts-removed/`.

### Example Commands

- Create a new script:
    ```bash
    brc-script -c
    ```

- List all available scripts:
    ```bash
    brc-script -l
    ```

- Enable a script:
    ```bash
    brc-script -e <index>
    ```

- Disable a script:
    ```bash
    brc-script -d <index>
    ```

- Remove a script:
    ```bash
    brc-script -r <index>
    ```

## Why Use This System?

Managing a large .bashrc file can become unmanageable, especially when adding multiple custom commands or functions. This system offers a structured approach to handle modular scripts, making it easier to enable or disable specific configurations without manually editing the .bashrc file each time.

### Benefits

- **Organization**: Keep your .bashrc clean and easy to maintain by separating scripts.
- **Simplicity**: Use simple commands to manage scripts without editing .bashrc directly.
- **Safety**: Removed scripts are safely backed up in the `scripts-removed/` directory.

## Contributing

Contributions are welcome! If you find any bugs or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).
