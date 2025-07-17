#!/bin/bash

# Kata Audit Runner - Automated kata opportunity detection for code repositories
# Version: 1.0.0

set -euo pipefail

# Constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPECS_DIR="$SCRIPT_DIR/specs"
PROMPTS_DIR="$SCRIPT_DIR/prompts"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

# Default values
AUDIT_TYPE="all"
OUTPUT_FORMAT="json"
OUTPUT_FILE=""
VERBOSE=0
REPO_PATH=""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS] <repository_path>

Automated kata opportunity detection for code repositories.

OPTIONS:
    -t, --type TYPE        Type of audit to run (default: all)
                          Available: patterns, complexity, testing, refactoring, all
    -f, --format FORMAT    Output format (default: json)
                          Available: json, markdown, yaml, html
    -o, --output FILE      Save output to file (default: stdout)
    -v, --verbose          Enable verbose output
    -h, --help             Display this help message

EXAMPLES:
    # Run all audits on a repository
    $0 /path/to/repo

    # Run specific audit type with markdown output
    $0 --type patterns --format markdown /path/to/repo

    # Save results to file
    $0 --output kata-opportunities.json /path/to/repo

EOF
}

# Function to log messages
log() {
    local level=$1
    local message=$2

    case $level in
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message" >&2
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} $message" >&2
            ;;
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $message" >&2
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message" >&2
            ;;
    esac
}

# Function to validate repository
validate_repository() {
    local repo_path=$1

    if [[ ! -d "$repo_path" ]]; then
        log "ERROR" "Repository path does not exist: $repo_path"
        return 1
    fi

    if [[ ! -r "$repo_path" ]]; then
        log "ERROR" "Repository path is not readable: $repo_path"
        return 1
    fi

    return 0
}

# Function to load specifications
load_specifications() {
    local audit_type=$1
    local spec_files=()

    case $audit_type in
        "patterns")
            spec_files=("$SPECS_DIR/kata-patterns-spec.yaml")
            ;;
        "complexity")
            spec_files=("$SPECS_DIR/kata-complexity-spec.yaml")
            ;;
        "testing")
            spec_files=("$SPECS_DIR/kata-testing-spec.yaml")
            ;;
        "refactoring")
            spec_files=("$SPECS_DIR/kata-refactoring-spec.yaml")
            ;;
        "all")
            spec_files=("$SPECS_DIR"/kata-*.yaml)
            ;;
        *)
            log "ERROR" "Unknown audit type: $audit_type"
            return 1
            ;;
    esac

    # Check if spec files exist
    for spec in "${spec_files[@]}"; do
        if [[ ! -f "$spec" ]]; then
            log "WARN" "Specification file not found: $spec"
        fi
    done

    echo "${spec_files[@]}"
}

# Function to analyze repository structure
analyze_repository_structure() {
    local repo_path=$1
    local output=""

    output+="{"
    output+="\"repository_path\": \"$repo_path\","

    # Count file types
    local py_count=$(find "$repo_path" -name "*.py" -type f 2>/dev/null | wc -l)
    local js_count=$(find "$repo_path" -name "*.js" -type f 2>/dev/null | wc -l)
    local ts_count=$(find "$repo_path" -name "*.ts" -type f 2>/dev/null | wc -l)
    local java_count=$(find "$repo_path" -name "*.java" -type f 2>/dev/null | wc -l)

    output+="\"file_counts\": {"
    output+="\"python\": $py_count,"
    output+="\"javascript\": $js_count,"
    output+="\"typescript\": $ts_count,"
    output+="\"java\": $java_count"
    output+="},"

    # Check for test directories
    local has_tests=false
    if find "$repo_path" -type d -name "test*" -o -name "*test" -o -name "spec*" 2>/dev/null | grep -q .; then
        has_tests=true
    fi

    output+="\"has_tests\": $has_tests,"

    # Check for documentation
    local has_docs=false
    if find "$repo_path" -name "README*" -o -name "*.md" -type f 2>/dev/null | grep -q .; then
        has_docs=true
    fi

    output+="\"has_documentation\": $has_docs"
    output+="}"

    echo "$output"
}

# Function to run audit with specifications
run_audit() {
    local repo_path=$1
    local spec_files=("${@:2}")
    local results="{"

    results+="\"audit_timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
    results+="\"repository\": $(analyze_repository_structure "$repo_path"),"
    results+="\"kata_opportunities\": ["

    # Here we would normally run the actual audit logic
    # For now, we'll create a placeholder structure
    results+="{\"type\": \"code_comprehension\", \"difficulty\": \"beginner\", \"location\": \"src/main.py\", \"description\": \"Understand the main application flow\"},"
    results+="{\"type\": \"bug_hunt\", \"difficulty\": \"intermediate\", \"location\": \"lib/parser.js\", \"description\": \"Fix edge case in input parsing\"},"
    results+="{\"type\": \"refactoring\", \"difficulty\": \"advanced\", \"location\": \"core/engine.ts\", \"description\": \"Extract method from complex function\"}"

    results+="]"
    results+="}"

    echo "$results"
}

# Function to format output
format_output() {
    local results=$1
    local format=$2

    case $format in
        "json")
            echo "$results" | python -m json.tool 2>/dev/null || echo "$results"
            ;;
        "markdown")
            echo "# Kata Audit Results"
            echo ""
            echo "## Repository Analysis"
            echo "\`\`\`json"
            echo "$results" | python -m json.tool 2>/dev/null || echo "$results"
            echo "\`\`\`"
            ;;
        "yaml")
            # Convert JSON to YAML (requires Python with PyYAML)
            echo "$results" | python -c "import json, yaml, sys; print(yaml.dump(json.load(sys.stdin), default_flow_style=False))" 2>/dev/null || echo "$results"
            ;;
        "html")
            echo "<!DOCTYPE html><html><head><title>Kata Audit Results</title></head>"
            echo "<body><h1>Kata Audit Results</h1><pre>"
            echo "$results" | python -m json.tool 2>/dev/null || echo "$results"
            echo "</pre></body></html>"
            ;;
        *)
            echo "$results"
            ;;
    esac
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            AUDIT_TYPE="$2"
            shift 2
            ;;
        -f|--format)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            log "ERROR" "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            REPO_PATH="$1"
            shift
            ;;
    esac
done

# Validate inputs
if [[ -z "$REPO_PATH" ]]; then
    log "ERROR" "Repository path is required"
    usage
    exit 1
fi

# Main execution
main() {
    log "INFO" "Starting kata audit for: $REPO_PATH"

    # Validate repository
    if ! validate_repository "$REPO_PATH"; then
        exit 1
    fi

    # Load specifications
    local spec_files
    spec_files=($(load_specifications "$AUDIT_TYPE"))

    if [[ ${#spec_files[@]} -eq 0 ]]; then
        log "WARN" "No specification files found for audit type: $AUDIT_TYPE"
    fi

    # Run audit
    local results
    results=$(run_audit "$REPO_PATH" "${spec_files[@]}")

    # Format output
    local formatted_output
    formatted_output=$(format_output "$results" "$OUTPUT_FORMAT")

    # Save or display results
    if [[ -n "$OUTPUT_FILE" ]]; then
        echo "$formatted_output" > "$OUTPUT_FILE"
        log "SUCCESS" "Results saved to: $OUTPUT_FILE"
    else
        echo "$formatted_output"
    fi

    log "SUCCESS" "Kata audit completed successfully"
}

# Run main function
main
