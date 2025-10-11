#!/usr/bin/env bash
#
# dstatus installer
# Installs dstatus Docker Compose TUI manager from local directory
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Constants
BINARY_NAME="dstatus"
# Download URL
REPO_URL="https://raw.githubusercontent.com/neoyubi/dstatus/main/dstatus"
VERSION="1.0.0"

# Installation directories (user-local by default, system-wide with --system flag)
USER_BIN_DIR="$HOME/.local/bin"
SYSTEM_BIN_DIR="/usr/local/bin"
INSTALL_DIR="$USER_BIN_DIR"
USE_SUDO=false
NON_INTERACTIVE=false

# Helper functions
print_header() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════╗"
    echo "║                                        ║"
    echo "║           dstatus installer            ║"
    echo "║   Docker Compose Project Manager TUI   ║"
    echo "║                                        ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

detect_package_manager() {
    if check_command pacman; then
        echo "pacman"
    elif check_command apt; then
        echo "apt"
    elif check_command dnf; then
        echo "dnf"
    elif check_command yum; then
        echo "yum"
    elif check_command zypper; then
        echo "zypper"
    else
        echo "unknown"
    fi
}

install_python_docker() {
    local pkg_manager=$(detect_package_manager)

    print_info "Detected package manager: $pkg_manager"

    case $pkg_manager in
        pacman)
            print_info "Installing python-docker via pacman..."
            sudo pacman -S --noconfirm python-docker
            ;;
        apt)
            print_info "Installing python3-docker via apt..."
            sudo apt update
            sudo apt install -y python3-docker
            ;;
        dnf)
            print_info "Installing python3-docker via dnf..."
            sudo dnf install -y python3-docker
            ;;
        yum)
            print_info "Installing python3-docker via yum..."
            sudo yum install -y python3-docker
            ;;
        zypper)
            print_info "Installing python3-docker via zypper..."
            sudo zypper install -y python3-docker
            ;;
        *)
            print_warning "Unknown package manager, attempting pip install..."
            if check_command pip3; then
                pip3 install docker
            elif check_command pip; then
                pip install docker
            else
                print_error "Could not install python-docker. Please install manually."
                return 1
            fi
            ;;
    esac
}

check_prerequisites() {
    local missing_deps=()

    print_info "Checking prerequisites..."

    # Check Python
    if ! check_command python3; then
        missing_deps+=("python3")
    else
        print_success "Python 3 found"
    fi

    # Check Docker
    if ! check_command docker; then
        missing_deps+=("docker")
    else
        print_success "Docker found"
    fi

    # Check python-docker module
    if ! python3 -c "import docker" 2>/dev/null; then
        print_warning "python-docker module not found"

        # Check if we're running interactively
        if [ "$NON_INTERACTIVE" = true ] || ! tty -s; then
            # Non-interactive mode, auto-install
            print_info "Auto-installing python-docker..."
            install_python_docker || missing_deps+=("python-docker")
        else
            # Interactive mode, ask user
            read -p "Install python-docker? [Y/n] " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
                install_python_docker || missing_deps+=("python-docker")
            else
                missing_deps+=("python-docker")
            fi
        fi
    else
        print_success "python-docker module found"
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_info "Please install the missing dependencies and try again."
        exit 1
    fi
}

ensure_bin_dir() {
    if [ ! -d "$INSTALL_DIR" ]; then
        print_info "Creating $INSTALL_DIR..."
        mkdir -p "$INSTALL_DIR"
        print_success "Directory created"
    fi
}

check_path() {
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        return 1
    fi
    return 0
}

add_to_path() {
    local shell_rc=""

    # Detect shell config file
    if [ -n "$BASH_VERSION" ]; then
        shell_rc="$HOME/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then
        shell_rc="$HOME/.zshrc"
    else
        # Try to detect from $SHELL
        case "$SHELL" in
            */bash)
                shell_rc="$HOME/.bashrc"
                ;;
            */zsh)
                shell_rc="$HOME/.zshrc"
                ;;
            *)
                shell_rc="$HOME/.profile"
                ;;
        esac
    fi

    print_warning "$INSTALL_DIR is not in your PATH"
    print_info "To use dstatus, you need to add it to your PATH."
    echo
    print_info "Add this line to your $shell_rc:"
    echo -e "  ${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
    echo

    # Check if we're running interactively
    if [ "$NON_INTERACTIVE" = true ] || ! tty -s; then
        # Non-interactive mode, auto-add to PATH
        print_info "Auto-adding to PATH..."
        echo "" >> "$shell_rc"
        echo "# Added by dstatus installer" >> "$shell_rc"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$shell_rc"
        print_success "PATH updated in $shell_rc"
        print_info "Run 'source $shell_rc' or restart your terminal to use dstatus"
    else
        # Interactive mode, ask user
        read -p "Would you like me to add it automatically? [Y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
            echo "" >> "$shell_rc"
            echo "# Added by dstatus installer" >> "$shell_rc"
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$shell_rc"
            print_success "PATH updated in $shell_rc"
            print_info "Run 'source $shell_rc' or restart your terminal to use dstatus"
        else
            print_info "Skipped PATH update. Add the line manually to use dstatus."
        fi
    fi
}

install_dstatus() {
    local source_file

    # Download dstatus
    print_info "Downloading dstatus..."
    source_file=$(mktemp)
    if check_command curl; then
        curl -fsSL "$REPO_URL" -o "$source_file"
    elif check_command wget; then
        wget -q "$REPO_URL" -O "$source_file"
    else
        print_error "Neither curl nor wget found. Please install one of them."
        exit 1
    fi

    if [ ! -f "$source_file" ]; then
        print_error "dstatus file not found at $source_file"
        exit 1
    fi

    ensure_bin_dir

    print_info "Installing dstatus to $INSTALL_DIR/$BINARY_NAME..."

    if [ "$USE_SUDO" = true ]; then
        sudo cp "$source_file" "$INSTALL_DIR/$BINARY_NAME"
        sudo chmod +x "$INSTALL_DIR/$BINARY_NAME"
    else
        cp "$source_file" "$INSTALL_DIR/$BINARY_NAME"
        chmod +x "$INSTALL_DIR/$BINARY_NAME"
    fi

    print_success "dstatus installed successfully!"

    # Check and update PATH if needed (only for user install)
    if [ "$USE_SUDO" = false ] && ! check_path; then
        add_to_path
    fi
}

verify_installation() {
    print_info "Verifying installation..."

    if [ -x "$INSTALL_DIR/$BINARY_NAME" ]; then
        print_success "dstatus is executable"
    else
        print_error "dstatus is not executable"
        return 1
    fi

    if check_command dstatus || [ -x "$INSTALL_DIR/$BINARY_NAME" ]; then
        print_success "dstatus is ready to use"
    else
        print_warning "dstatus is not in PATH. You may need to add $INSTALL_DIR to your PATH."
    fi
}

print_completion() {
    echo
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                        ║${NC}"
    echo -e "${GREEN}║   Installation completed successfully! ║${NC}"
    echo -e "${GREEN}║                                        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo

    if check_path; then
        echo -e "${CYAN}Ready to go!${NC} Start dstatus by running:"
        echo
        echo -e "  ${GREEN}dstatus${NC}"
        echo
    else
        print_warning "PATH update required. Restart your terminal or run:"
        echo -e "  ${CYAN}source ~/.bashrc${NC}  ${BLUE}# or ~/.zshrc${NC}"
        echo
        echo -e "Then start dstatus:"
        echo -e "  ${GREEN}dstatus${NC}"
        echo
    fi
    print_info "Make sure Docker is running before launching!"
    echo
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --system)
                INSTALL_DIR="$SYSTEM_BIN_DIR"
                USE_SUDO=true
                print_info "System-wide installation mode enabled"
                shift
                ;;
            --non-interactive)
                NON_INTERACTIVE=true
                shift
                ;;
            --help|-h)
                echo "dstatus installer"
                echo
                echo "Usage: $0 [OPTIONS]"
                echo
                echo "Options:"
                echo "  --system           Install system-wide to /usr/local/bin (requires sudo)"
                echo "  --non-interactive  Skip all prompts and use defaults"
                echo "  --help, -h         Show this help message"
                echo
                echo "By default, installs to ~/.local/bin (no sudo required)"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
}

# Auto-detect non-interactive mode if piped
if ! tty -s; then
    NON_INTERACTIVE=true
fi

main() {
    parse_args "$@"
    print_header

    # Check if already installed
    if check_command dstatus; then
        print_warning "dstatus is already installed at $(which dstatus)"

        # Check if we're running interactively
        if [ "$NON_INTERACTIVE" = true ] || ! tty -s; then
            # Non-interactive mode, proceed with reinstall
            print_info "Proceeding with reinstall..."
        else
            # Interactive mode, ask user
            read -p "Reinstall? [y/N] " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "Installation cancelled."
                exit 0
            fi
        fi
    fi

    # Run installation steps
    check_prerequisites
    install_dstatus
    verify_installation
    print_completion
}

# Run main function
main "$@"
