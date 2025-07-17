# AI Repo Kata Generator

A lean audit system for identifying kata opportunities in code repositories. This tool analyzes codebases to generate programming exercises (katas) that help developers improve through deliberate practice.

## Features

- **Automated Pattern Detection**: Identifies code patterns suitable for kata exercises
- **Complexity Analysis**: Measures code complexity to generate appropriate difficulty levels
- **Testing Gap Detection**: Finds untested code for test-writing exercises
- **Refactoring Opportunities**: Detects code smells for refactoring practice
- **Multiple Output Formats**: JSON, Markdown, YAML, and HTML reports

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/ai-repo-kata-generator.git
cd ai-repo-kata-generator

# Make scripts executable
chmod +x kata-audit-runner.sh test-kata-audit.sh

# Run audit on a repository
./kata-audit-runner.sh /path/to/your/repo

# Run with specific options
./kata-audit-runner.sh --type patterns --format markdown --output results.md /path/to/repo

# Analyze a repository with Claude
python3 analyze_repo.py /path/or/url/to/repo
```

## Project Structure

```
ai-repo-kata-generator/
├── kata-audit-runner.sh          # Main audit script
├── analyze_repo.py               # Claude-based repo analyzer
├── specs/                        # YAML specifications for pattern detection
│   ├── kata-patterns-spec.yaml   # Code pattern detection rules
│   ├── kata-complexity-spec.yaml # Complexity analysis rules
│   ├── kata-testing-spec.yaml    # Testing opportunity detection
│   └── kata-refactoring-spec.yaml # Refactoring opportunity detection
├── prompts/                      # AI prompt templates
│   └── kata-generation-prompt.md # Templates for generating katas
├── templates/                    # Kata exercise templates
│   └── kata-template.yaml        # Standard kata format
├── docs/                         # Documentation
│   ├── research.md               # Original research document
│   ├── taxonomy.md               # Kata classification system
│   └── kata-audit-guide.md       # User guide
├── scripts/                      # Utility scripts
├── tests/                        # Test files
├── examples/                     # Example repositories
└── test-kata-audit.sh            # Test suite
```

## Kata Types

Based on the comprehensive taxonomy, the system generates these kata types:

1. **Code Tour** - Repository exploration
2. **Comprehension** - Understanding existing code
3. **Bug Hunt** - Finding and fixing bugs
4. **Refactor** - Improving code structure
5. **Test Writing** - Creating test coverage
6. **Feature Addition** - Adding new functionality
7. **Performance** - Optimization challenges
8. **Architecture** - System design exercises
9. **Integration** - Connecting components
10. **Module Design** - Creating reusable components

## Progression Levels

Katas are categorized by difficulty:

- **Explore**: Read-only understanding tasks
- **Tinker**: Small, local code changes
- **Contribute**: Guided feature implementation
- **Engineer**: Independent design and implementation
- **Architect**: System-wide architectural decisions

## Usage Examples

### Basic Audit

```bash
./kata-audit-runner.sh /path/to/repo
```

### Specific Audit Type

```bash
./kata-audit-runner.sh --type refactoring /path/to/repo
```

### Generate Markdown Report

```bash
./kata-audit-runner.sh --format markdown --output kata-report.md /path/to/repo
```

### CI/CD Integration

```yaml
# .github/workflows/kata-audit.yml
name: Kata Audit
on: [push]
jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: ./kata-audit-runner.sh --output kata-opportunities.json .
```

## Testing

Run the test suite to verify the installation:

```bash
./test-kata-audit.sh
```

## Documentation

- [Kata Audit Guide](docs/kata-audit-guide.md) - Comprehensive user guide
- [Research](docs/research.md) - Original research on kata progression systems
- [Taxonomy](docs/taxonomy.md) - Complete classification system

## Contributing

Contributions are welcome! To add new patterns or improve the system:

1. Add specifications to `specs/`
2. Update documentation in `docs/`
3. Add tests to `test-kata-audit.sh`
4. Submit a pull request

## License

MIT License - see LICENSE file for details

## Acknowledgments

This project builds on research into deliberate practice and programming education, creating a practical tool for generating context-specific programming exercises from real codebases.
