# dstatus

<div align="center">

**A minimal, aesthetic TUI for managing Docker Compose projects**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Python 3.7+](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)

</div>

---

## Why dstatus?

As someone who works extensively with Docker Compose projects across multiple hosts, I found myself constantly switching between terminal windows, running repetitive commands, and losing track of container states. I wanted something **fast**, **intuitive**, and **beautiful** that would let me manage everything from one place.

If you've been looking for a lightweight, compose-first Docker manager that just *works*, stop looking. **dstatus** is built for developers who live in the terminal and need quick access to their containerized applications.

## Features

### Compose-First Design
- **Automatic project grouping** - Containers organized by Docker Compose project
- **Full project control** - Up, down, restart, build, pull - all from one place
- **Integrated volume management** - View, inspect, and manage volumes with ease

### Blazing Fast Navigation
- **Keyboard-driven** - Everything is a keystroke away
- **Arrow key navigation** - Intuitive up/down movement
- **Direct shortcuts** - Press letter keys to execute actions immediately
- **Responsive controls** - Instant feedback on all operations

### Beautiful TUI
- **Full-screen detail views** - Smooth transitions, no jarring popups
- **Color-coded status** - Running (green), stopped (red), paused (yellow)
- **Clean typography** - Unicode box drawing for crisp interfaces
- **Centered menus** - Aesthetic and easy to read

### Powerful Operations

**Container Operations:**
- View logs (with Ctrl+C to exit)
- Start/Stop/Restart
- Pause/Unpause
- Exec shell (bash/sh)
- Inspect configuration
- Remove containers

**Project Operations:**
- `docker compose up -d`
- `docker compose down`
- `docker compose restart`
- `docker compose pull`
- `docker compose build`
- View project logs
- Manage volumes
- View compose files
- Project info & images

### Safety Features
- **Confirmation dialogs** for destructive operations
- **Visual warnings** for dangerous actions (red highlights)
- **Data loss prevention** - Clear messaging before volume deletion

## Installation

### Quick Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/neoyubi/dstatus/main/install.sh | bash
```

### Manual Installation

**Prerequisites:**
- Python 3.7+
- Docker with Compose v2
- `python-docker` library

**Arch Linux:**
```bash
sudo pacman -S python-docker
curl -fsSL https://raw.githubusercontent.com/neoyubi/dstatus/main/dstatus -o /usr/local/bin/dstatus
sudo chmod +x /usr/local/bin/dstatus
```

**Debian/Ubuntu:**
```bash
sudo apt install python3-docker
curl -fsSL https://raw.githubusercontent.com/neoyubi/dstatus/main/dstatus -o /usr/local/bin/dstatus
sudo chmod +x /usr/local/bin/dstatus
```

**Other distros (via pip):**
```bash
pip install docker
curl -fsSL https://raw.githubusercontent.com/neoyubi/dstatus/main/dstatus -o /usr/local/bin/dstatus
sudo chmod +x /usr/local/bin/dstatus
```

## Usage

Simply run:

```bash
dstatus
```

### Navigation

**List View:**
- `↑/↓` - Navigate through projects and containers
- `Enter` - Open detail view
- `q` - Quit
- `F5` - Refresh

**Detail View:**
- `↑/↓` - Navigate menu options
- `Enter` - Execute selected action
- `Letter keys` - Direct shortcuts (e.g., press `u` for "Up")
- `ESC` or `q` - Back to list

**Log Viewing:**
- `Ctrl+C` - Exit logs and return to manager

### Keyboard Shortcuts

**Container Actions:**
- `l` - View Logs
- `r` - Restart
- `s` - Stop
- `S` - Start (capital S)
- `p` - Pause/Unpause
- `e` - Exec Shell
- `i` - Inspect
- `R` - Remove (capital R)

**Project Actions:**
- `u` - Up (Start All)
- `d` - Down (Stop All)
- `r` - Restart All
- `p` - Pull Images
- `b` - Build
- `l` - View Logs (All)
- `v` - Manage Volumes
- `c` - View Compose File
- `i` - Project Info

## Requirements

- **Docker** - Container runtime
- **Docker Compose v2** - For project management (installed with modern Docker)
- **Python 3.7+** - Runtime environment
- **python-docker** - Docker API client
- **Terminal with Unicode support** - For pretty box drawing

## Comparison with Lazydocker

While [Lazydocker](https://github.com/jesseduffield/lazydocker) is excellent, **dstatus** offers:

- **Simpler codebase** - Single Python file, easy to hack
- **Faster installation** - No compilation needed
- **Compose-first** - Explicitly designed around Docker Compose projects
- **Cleaner detail views** - Full-screen transitions instead of panels
- **Built-in volume management** - Integrated TUI for volume operations

Use Lazydocker if you need metrics/graphs and prefer Go tools.
Use dstatus if you want something minimal, hackable, and Compose-focused.

## Configuration

dstatus works out of the box with no configuration needed. It automatically detects:
- Docker Compose projects via container labels
- Container working directories
- Service relationships

## Troubleshooting

**"Error connecting to Docker"**
- Ensure Docker is running: `docker ps`
- Check permissions: Add user to docker group with `sudo usermod -aG docker $USER`

**"No module named 'docker'"**
- Install python-docker: See installation instructions above

**Containers not grouped**
- Only containers launched with `docker compose` are grouped
- Standalone containers appear in "[Standalone Containers]" section

## Development

**Clone and run:**
```bash
git clone https://github.com/neoyubi/dstatus.git
cd dstatus
chmod +x dstatus
./dstatus
```

**Code structure:**
- `DockerManager` - Docker API interactions
- `DockerTUI` - Terminal UI rendering and event handling
- Single file design for easy distribution

## Contributing

Contributions are welcome! This is a personal project that solved my specific needs, but I'm happy to accept:
- Bug fixes
- Performance improvements
- New features that maintain the minimalist philosophy
- Documentation improvements

## License

MIT License - See LICENSE file for details

## Disclaimer

**IMPORTANT:** This software is provided "as-is" without any warranty or guarantee. The author assumes **NO RESPONSIBILITY OR LIABILITY** for any destructive, catastrophic, or unintended results that may occur from using this tool, including but not limited to data loss, container damage, or system issues.

**However**, I guarantee that this project is:
- Free of malware and malicious code
- Open source and auditable
- A simple developer tool with no hidden functionality

Always review Docker operations before confirming destructive actions. Use at your own risk.

## Support

- **Bug reports:** [GitHub Issues](https://github.com/neoyubi/dstatus/issues)
- **Feature requests:** [GitHub Issues](https://github.com/neoyubi/dstatus/issues)
- **Star the repo** if you find it useful!

---

<div align="center">

**Made for the terminal**

[Report Bug](https://github.com/neoyubi/dstatus/issues) · [Request Feature](https://github.com/neoyubi/dstatus/issues)

</div>
