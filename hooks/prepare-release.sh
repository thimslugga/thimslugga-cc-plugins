#!/bin/bash
set -euo pipefail

# This script automates the release preparation process with AI assistance
# Optimized with pre-computation and smart diff filtering

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PACKAGE_JSON="${PROJECT_ROOT}/package.json"
CHANGELOG_FILE="${PROJECT_ROOT}/CHANGELOG.md"
README_FILE="${PROJECT_ROOT}/README.md"
PACKAGE_NAME="claudekit"

# Default values
DRY_RUN=false
INTERACTIVE=true
RELEASE_TYPE=""

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_step() {
    echo -e "${PURPLE}🔄 $1${NC}"
}

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

AI-powered release preparation script for Claudekit.

OPTIONS:
    -t, --type TYPE     Release type: patch, minor, major
    -d, --dry-run       Perform a dry run without making changes
    -y, --yes           Non-interactive mode (use defaults)
    -h, --help          Show this help message

EXAMPLES:
    $0                          # Interactive mode
    $0 --type minor             # Prepare minor release
    $0 --type patch --dry-run   # Dry run for patch release
    $0 --type major --yes       # Non-interactive major release

EOF
}
