#!/bin/bash

# Kata Claude CLI - Interface to pull prompts/specs and integrate with Claude Code
# Version: 1.0.0

set -euo pipefail

# Constants
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPECS_DIR="$SCRIPT_DIR/specs"
PROMPTS_DIR="$SCRIPT_DIR/prompts"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

# Default values
ACTION=""
SPEC_TYPE=""
REPO_PATH=""
OUTPUT_FILE=""
CLAUDE_CODE_MODE=0
VERBOSE=0

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS] <action> [arguments]

CLI tool to pull prompts/specs and integrate with Claude Code for kata generation.

ACTIONS:
    get-prompt [type]          Get prompt template for kata generation
    get-spec [type]            Get specification for kata pattern detection
    generate [repo_path]       Generate katas for a repository using Claude Code
    list-prompts               List all available prompt types
    list-specs                 List all available specifications

OPTIONS:
    -o, --output FILE          Save output to file (default: stdout)
    -c, --claude-code          Format output for Claude Code integration
    -v, --verbose              Enable verbose output
    -h, --help                 Display this help message

PROMPT TYPES:
    base                       Base kata generation template
    patterns                   Pattern detection specific
    complexity                 Complexity analysis specific
    testing                    Testing opportunities specific
    refactoring               Refactoring opportunities specific
    job-posting               Job posting analysis specific
    onboarding                Team onboarding specific
    skill-development         Skill development specific

SPEC TYPES:
    patterns                   Code pattern detection rules
    complexity                 Complexity analysis rules
    testing                    Testing opportunity detection
    refactoring               Refactoring opportunity detection

EXAMPLES:
    # Get base prompt template
    $0 get-prompt base

    # Get pattern detection spec
    $0 get-spec patterns

    # Generate katas for a repository with Claude Code integration
    $0 --claude-code generate /path/to/repo

    # List all available prompts
    $0 list-prompts

    # Save prompt to file
    $0 --output my-prompt.md get-prompt patterns

EOF
}

# Function to log messages
log() {
    local level=$1
    local message=$2
    
    if [[ $VERBOSE -eq 1 ]]; then
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
    fi
}

# Function to extract specific prompt section
extract_prompt_section() {
    local prompt_file="$PROMPTS_DIR/kata-generation-prompt.md"
    local section_type=$1
    local in_section=0
    local section_content=""
    
    case $section_type in
        "base")
            # Extract base prompt template
            awk '/^## Base Prompt Template/,/^## Specific Audit Type Prompts/ { 
                if (!/^## / || /^## Base Prompt Template/) print 
            }' "$prompt_file" | sed '1d;$d'
            ;;
        "patterns")
            # Extract pattern detection prompt
            awk '/^### Pattern Detection Prompt/,/^### Complexity Analysis Prompt/ { 
                if (!/^### / || /^### Pattern Detection Prompt/) print 
            }' "$prompt_file" | sed '1d;$d'
            ;;
        "complexity")
            # Extract complexity analysis prompt
            awk '/^### Complexity Analysis Prompt/,/^### Testing Opportunities Prompt/ { 
                if (!/^### / || /^### Complexity Analysis Prompt/) print 
            }' "$prompt_file" | sed '1d;$d'
            ;;
        "testing")
            # Extract testing opportunities prompt
            awk '/^### Testing Opportunities Prompt/,/^### Refactoring Opportunities Prompt/ { 
                if (!/^### / || /^### Testing Opportunities Prompt/) print 
            }' "$prompt_file" | sed '1d;$d'
            ;;
        "refactoring")
            # Extract refactoring opportunities prompt
            awk '/^### Refactoring Opportunities Prompt/,/^## Context-Specific Prompts/ { 
                if (!/^### / || /^### Refactoring Opportunities Prompt/) print 
            }' "$prompt_file" | sed '1d;$d'
            ;;
        "job-posting")
            # Extract job posting analysis prompt
            awk '/^### For Job Posting Analysis/,/^### For Team Onboarding/ { 
                if (!/^### / || /^### For Job Posting Analysis/) print 
            }' "$prompt_file" | sed '1d;$d'
            ;;
        "onboarding")
            # Extract team onboarding prompt
            awk '/^### For Team Onboarding/,/^### For Skill Development/ { 
                if (!/^### / || /^### For Team Onboarding/) print 
            }' "$prompt_file" | sed '1d;$d'
            ;;
        "skill-development")
            # Extract skill development prompt
            awk '/^### For Skill Development/,/^## Output Examples/ { 
                if (!/^### / || /^### For Skill Development/) print 
            }' "$prompt_file" | sed '1d;$d'
            ;;
        *)
            log "ERROR" "Unknown prompt type: $section_type"
            return 1
            ;;
    esac
}

# Function to get prompt
get_prompt() {
    local prompt_type=$1
    local content=""
    
    log "INFO" "Retrieving prompt: $prompt_type"
    
    content=$(extract_prompt_section "$prompt_type")
    
    if [[ $CLAUDE_CODE_MODE -eq 1 ]]; then
        # Format for Claude Code integration
        echo "# Kata Generation Prompt: $prompt_type"
        echo ""
        echo "Use the following prompt with the specifications in specs/ to generate katas:"
        echo ""
        echo "$content"
        echo ""
        echo "## Integration Instructions:"
        echo "1. Replace [CODE_PATH] with the target repository path"
        echo "2. Reference the appropriate spec file from specs/"
        echo "3. Generate katas following the format in the prompt"
        echo "4. Ensure alignment with the taxonomy in docs/taxonomy.md"
    else
        echo "$content"
    fi
}

# Function to get specification
get_spec() {
    local spec_type=$1
    local spec_file=""
    
    case $spec_type in
        "patterns")
            spec_file="$SPECS_DIR/kata-patterns-spec.yaml"
            ;;
        "complexity")
            spec_file="$SPECS_DIR/kata-complexity-spec.yaml"
            ;;
        "testing")
            spec_file="$SPECS_DIR/kata-testing-spec.yaml"
            ;;
        "refactoring")
            spec_file="$SPECS_DIR/kata-refactoring-spec.yaml"
            ;;
        *)
            log "ERROR" "Unknown spec type: $spec_type"
            return 1
            ;;
    esac
    
    log "INFO" "Retrieving specification: $spec_type"
    
    if [[ ! -f "$spec_file" ]]; then
        log "ERROR" "Specification file not found: $spec_file"
        return 1
    fi
    
    if [[ $CLAUDE_CODE_MODE -eq 1 ]]; then
        echo "# Kata Specification: $spec_type"
        echo ""
        echo "## File: $(basename "$spec_file")"
        echo ""
        echo '```yaml'
        cat "$spec_file"
        echo '```'
    else
        cat "$spec_file"
    fi
}

# Function to generate Claude Code command
generate_claude_command() {
    local repo_path=$1
    
    if [[ ! -d "$repo_path" ]]; then
        log "ERROR" "Repository path does not exist: $repo_path"
        return 1
    fi
    
    # Get absolute path
    repo_path=$(cd "$repo_path" && pwd)
    
    cat << EOF
# Claude Code Integration Command

To generate katas for the repository at $repo_path, use this command with Claude Code:

\`\`\`bash
claude-code --message "I'm using the kata audit system from ai-repo-kata-generator.
Please analyze my codebase at $repo_path and:

1. Use the specifications in $SPECS_DIR to identify patterns
2. Generate katas following the format in $PROMPTS_DIR/kata-generation-prompt.md
3. Ensure katas align with the taxonomy in $SCRIPT_DIR/docs/taxonomy.md
4. Create a mix of difficulty levels
5. Output in JSON format

Focus on:
- Complex functions that need refactoring
- Missing test coverage
- Code duplication
- Performance bottlenecks
- Security vulnerabilities"
\`\`\`

## Alternative: Step-by-step approach

1. First, analyze patterns:
\`\`\`bash
claude-code --message "Analyze $repo_path using the pattern detection rules in $SPECS_DIR/kata-patterns-spec.yaml. List all complex functions, missing tests, and code duplication."
\`\`\`

2. Then generate katas:
\`\`\`bash
claude-code --message "Based on the patterns found, generate katas using the template in $PROMPTS_DIR/kata-generation-prompt.md. Create at least 5 katas of varying difficulty levels."
\`\`\`

## Using specific prompts

For targeted kata generation:

\`\`\`bash
# For refactoring katas
claude-code --message "$(cat $PROMPTS_DIR/kata-generation-prompt.md | sed -n '/### Refactoring Opportunities Prompt/,/^###/p' | sed '1d' | sed '$d') Apply this to $repo_path"

# For testing katas
claude-code --message "$(cat $PROMPTS_DIR/kata-generation-prompt.md | sed -n '/### Testing Opportunities Prompt/,/^###/p' | sed '1d' | sed '$d') Apply this to $repo_path"
\`\`\`
EOF
}

# Function to list available prompts
list_prompts() {
    echo "Available prompt types:"
    echo ""
    echo "  base                  - Base kata generation template"
    echo "  patterns              - Pattern detection specific prompts"
    echo "  complexity            - Complexity analysis specific prompts"
    echo "  testing               - Testing opportunities specific prompts"
    echo "  refactoring           - Refactoring opportunities specific prompts"
    echo "  job-posting           - Job posting analysis prompts"
    echo "  onboarding            - Team onboarding prompts"
    echo "  skill-development     - Skill development prompts"
}

# Function to list available specs
list_specs() {
    echo "Available specifications:"
    echo ""
    for spec_file in "$SPECS_DIR"/*.yaml; do
        if [[ -f "$spec_file" ]]; then
            basename=$(basename "$spec_file" .yaml)
            spec_type=${basename#kata-}
            spec_type=${spec_type%-spec}
            echo "  $spec_type - $(head -n 2 "$spec_file" | tail -n 1 | sed 's/# //')"
        fi
    done
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -c|--claude-code)
            CLAUDE_CODE_MODE=1
            shift
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        get-prompt|get-spec|generate|list-prompts|list-specs)
            ACTION="$1"
            shift
            break
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate action
if [[ -z "$ACTION" ]]; then
    log "ERROR" "No action specified"
    usage
    exit 1
fi

# Execute action
output=""
case $ACTION in
    "get-prompt")
        if [[ $# -lt 1 ]]; then
            log "ERROR" "Prompt type required"
            usage
            exit 1
        fi
        output=$(get_prompt "$1")
        ;;
    "get-spec")
        if [[ $# -lt 1 ]]; then
            log "ERROR" "Spec type required"
            usage
            exit 1
        fi
        output=$(get_spec "$1")
        ;;
    "generate")
        if [[ $# -lt 1 ]]; then
            log "ERROR" "Repository path required"
            usage
            exit 1
        fi
        output=$(generate_claude_command "$1")
        ;;
    "list-prompts")
        output=$(list_prompts)
        ;;
    "list-specs")
        output=$(list_specs)
        ;;
    *)
        log "ERROR" "Unknown action: $ACTION"
        usage
        exit 1
        ;;
esac

# Output results
if [[ -n "$OUTPUT_FILE" ]]; then
    echo "$output" > "$OUTPUT_FILE"
    log "SUCCESS" "Output saved to: $OUTPUT_FILE"
else
    echo "$output"
fi