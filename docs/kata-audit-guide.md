# Kata Audit Guide

A lean, focused system for identifying kata opportunities in code repositories.

## Overview

The Kata Audit system analyzes codebases to identify opportunities for creating programming exercises (katas) that help developers practice specific skills through deliberate practice.

## Quick Start

```bash
# Run all audits on a repository
./kata-audit-runner.sh /path/to/repo

# Run specific audit type
./kata-audit-runner.sh --type patterns --format markdown /path/to/repo

# Save results to file
./kata-audit-runner.sh --output kata-opportunities.json /path/to/repo
```

## Audit Types

### 1. Pattern Detection (`--type patterns`)
Identifies code patterns suitable for kata exercises:
- Complex functions needing refactoring
- Missing test coverage
- Code duplication
- Security vulnerabilities
- Performance bottlenecks

### 2. Complexity Analysis (`--type complexity`)
Analyzes code complexity metrics:
- Cyclomatic complexity
- Cognitive complexity
- Dependency complexity
- Data flow complexity

### 3. Testing Opportunities (`--type testing`)
Finds testing gaps:
- Untested public APIs
- Missing edge case coverage
- Test quality issues
- Integration test gaps

### 4. Refactoring Opportunities (`--type refactoring`)
Detects code smells:
- Long methods
- Feature envy
- Primitive obsession
- Code duplication

## Output Formats

- **JSON** (default): Machine-readable format for integration
- **Markdown**: Human-readable reports
- **YAML**: Configuration-friendly format
- **HTML**: Web-viewable reports

## Specification Schema

Each specification in `specs/` follows this structure:

```yaml
kata_patterns:
  - name: "Pattern Name"
    category: "category_type"
    kata_type: "exercise_type"
    skill_domains: ["skill1", "skill2"]
    progression_level: "explore|tinker|contribute|engineer|architect"
    hints: ["detection_pattern1", "detection_pattern2"]
    report_fields: ["field1", "field2"]
```

## Kata Types

Based on the taxonomy defined in `docs/taxonomy.md`:

1. **Code Tour**: Repository exploration exercises
2. **Comprehension**: Understanding existing code
3. **Bug Hunt**: Finding and fixing bugs
4. **Refactor**: Improving code structure
5. **Test Writing**: Creating test coverage
6. **Feature Addition**: Adding new functionality
7. **Performance**: Optimization challenges
8. **Architecture**: System design exercises
9. **Integration**: Connecting components
10. **Module Design**: Creating reusable components

## Progression Levels

Katas are categorized by difficulty:

1. **Explore**: Understand and navigate (read-only)
2. **Tinker**: Make small, local changes
3. **Contribute**: Implement features with guidance
4. **Engineer**: Design and implement independently
5. **Architect**: Make system-wide decisions

## Integration Examples

### CI/CD Pipeline

```yaml
# .github/workflows/kata-audit.yml
name: Kata Audit
on: [push, pull_request]
jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Kata Audit
        run: |
          ./kata-audit-runner.sh --output audit.json .
      - name: Upload Results
        uses: actions/upload-artifact@v2
        with:
          name: kata-opportunities
          path: audit.json
```

### Pre-commit Hook

```bash
#!/bin/sh
# .git/hooks/pre-commit
./kata-audit-runner.sh --type patterns . > /dev/null
if [ $? -ne 0 ]; then
    echo "New kata opportunities detected. Consider creating exercises."
fi
```

## Customization

### Adding New Patterns

Create a new specification in `specs/`:

```yaml
# specs/kata-custom-spec.yaml
custom_patterns:
  - name: "Your Pattern"
    category: "pattern_category"
    kata_type: "exercise_type"
    hints: ["detection_hints"]
    report_fields: ["relevant_fields"]
```

### Extending the Runner

The `kata-audit-runner.sh` script can be extended:

```bash
# Add to the load_specifications function
"custom")
    spec_files=("$SPECS_DIR/kata-custom-spec.yaml")
    ;;
```

## Best Practices

1. **Regular Audits**: Run audits regularly to identify new kata opportunities
2. **Progressive Difficulty**: Start with "explore" level katas before advancing
3. **Context Matters**: Consider the codebase context when creating katas
4. **Measure Progress**: Track which katas are completed and by whom
5. **Iterate**: Refine katas based on learner feedback

## Troubleshooting

### No Opportunities Found
- Ensure the repository path is correct
- Check that specification files exist in `specs/`
- Verify the codebase contains the patterns you're searching for

### Script Errors
- Ensure bash version 4.0+ is installed
- Check file permissions: `chmod +x kata-audit-runner.sh`
- Verify Python is installed for JSON/YAML formatting

## Next Steps

1. Run your first audit: `./kata-audit-runner.sh /path/to/repo`
2. Review the opportunities found
3. Create katas using the templates in `templates/`
4. Share katas with your team
5. Track completion and gather feedback
