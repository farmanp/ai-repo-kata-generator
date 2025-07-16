# Kata Generation Prompts

## Base Prompt Template

```
Analyze the code at [CODE_PATH] using the kata audit specifications in specs/.

Generate kata exercises following this format:

**Kata Title**: [Descriptive name]
**Type**: [From taxonomy: comprehension, refactor, bug_hunt, etc.]
**Skill Domains**: [From taxonomy: testing, refactoring, architecture, etc.]
**Progression Level**: [explore, tinker, contribute, engineer, architect]
**Time Estimate**: [15-120 minutes]

**Scenario**:
[2-3 sentence context setting up why this task matters]

**Challenge**:
[Specific task the developer needs to complete]

**Acceptance Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Hints** (optional):
- Hint 1
- Hint 2

**Learning Objectives**:
- Objective 1
- Objective 2
```

## Specific Audit Type Prompts

### Pattern Detection Prompt

```
Review [CODE_PATH] for the following patterns:
- Complex functions (>50 lines, cyclomatic complexity >10)
- Missing test coverage
- Code duplication
- Security vulnerabilities
- Performance bottlenecks

For each pattern found, create a kata that helps developers:
1. Recognize the pattern
2. Understand why it's problematic
3. Practice fixing it

Use the specifications in specs/kata-patterns-spec.yaml for detection criteria.
```

### Complexity Analysis Prompt

```
Analyze the complexity metrics in [CODE_PATH]:
- Cyclomatic complexity
- Cognitive complexity
- Dependency coupling
- Data flow complexity

Create progressive katas that:
- Start with understanding the complex code (explore level)
- Move to simplifying parts (tinker level)
- Progress to redesigning components (engineer level)

Reference specs/kata-complexity-spec.yaml for thresholds.
```

### Testing Opportunities Prompt

```
Identify testing gaps in [CODE_PATH]:
- Public APIs without tests
- Uncovered edge cases
- Missing integration tests
- Poor test quality

Generate test-writing katas that teach:
- Test design principles
- Edge case identification
- Test maintainability
- Coverage strategies

Use specs/kata-testing-spec.yaml for patterns.
```

### Refactoring Opportunities Prompt

```
Find refactoring opportunities in [CODE_PATH]:
- Long methods
- Feature envy
- Primitive obsession
- Code duplication

Create refactoring katas with:
- Clear code smells to identify
- Step-by-step refactoring guidance
- Before/after comparisons
- Design principle explanations

Reference specs/kata-refactoring-spec.yaml for code smells.
```

## Context-Specific Prompts

### For Job Posting Analysis

```
Given this job posting: [JOB_DESCRIPTION]

And this codebase: [CODE_PATH]

Create katas that help developers:
1. Build skills mentioned in the job posting
2. Practice with similar technologies
3. Work at the appropriate seniority level

Match kata difficulty to the role level (junior/senior/etc).
```

### For Team Onboarding

```
Analyze [CODE_PATH] to create an onboarding kata sequence:

1. Code Tour katas - explore the repository structure
2. Comprehension katas - understand key components
3. Bug Hunt katas - fix simple issues
4. Feature Addition katas - add small features

Progress from read-only (explore) to making changes (contribute).
```

### For Skill Development

```
Target skill: [SPECIFIC_SKILL]
Codebase: [CODE_PATH]

Create a kata progression path:
1. Beginner: Recognize [SKILL] patterns
2. Intermediate: Apply [SKILL] in isolated scenarios
3. Advanced: Use [SKILL] in complex, real-world situations

Each kata should build on the previous one.
```

## Output Examples

### Example 1: Refactoring Kata

```markdown
**Kata Title**: Extract Method from Order Calculator
**Type**: refactor
**Skill Domains**: ["refactoring", "code_smell_detection"]
**Progression Level**: tinker
**Time Estimate**: 30 minutes

**Scenario**:
The order calculation logic in OrderService has grown complex over time. New team members struggle to understand the discount rules, and bugs keep appearing in edge cases.

**Challenge**:
Refactor the calculateTotal() method by extracting the discount calculation logic into separate, well-named methods.

**Acceptance Criteria**:
- [ ] Extract at least 3 methods from calculateTotal()
- [ ] Each extracted method has a single responsibility
- [ ] All tests still pass
- [ ] The main method is under 20 lines

**Hints**:
- Look for comments that explain what a code block does
- Group related calculations together

**Learning Objectives**:
- Recognize the "Long Method" code smell
- Apply the "Extract Method" refactoring technique
- Improve code readability through better naming
```

### Example 2: Testing Kata

```markdown
**Kata Title**: Edge Case Testing for User Validator
**Type**: test_writing
**Skill Domains**: ["testing", "debugging"]
**Progression Level**: contribute
**Time Estimate**: 45 minutes

**Scenario**:
The UserValidator class handles user input validation but recent production issues revealed several edge cases aren't properly tested. You need to improve test coverage.

**Challenge**:
Write comprehensive tests for the validateEmail() method, ensuring all edge cases are covered.

**Acceptance Criteria**:
- [ ] Test valid email formats
- [ ] Test invalid email formats
- [ ] Test boundary conditions (empty, null, very long)
- [ ] Test Unicode and special characters
- [ ] Achieve 100% branch coverage

**Learning Objectives**:
- Identify edge cases systematically
- Write thorough test cases
- Understand email validation complexity
```

## Prompt Optimization Tips

1. **Be Specific**: Reference exact file paths and line numbers
2. **Use Context**: Include surrounding code for better understanding
3. **Progressive Difficulty**: Create kata sequences, not just individual exercises
4. **Real-World Relevance**: Connect katas to actual development scenarios
5. **Measurable Outcomes**: Include clear acceptance criteria

## Integration with AI Tools

When using with AI assistants:

```
I'm using the kata audit system from ai-repo-kata-generator.
Please analyze my codebase at [PATH] and:

1. Use the specifications in specs/ to identify patterns
2. Generate katas following the format in prompts/kata-generation-prompt.md
3. Ensure katas align with the taxonomy in docs/taxonomy.md
4. Create a mix of difficulty levels
5. Output in [JSON/Markdown/YAML] format
```