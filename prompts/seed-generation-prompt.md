# Seed Generation Prompt

Use this prompt to create focused seed lessons from a repository. Seeds are micro exercises that teach a single concept or behavior.

Reference the taxonomy in `specs/seed-spec.yaml` and format your output like:

```
seed:
  title: "Descriptive seed title"
  source_reference: "relative/path/to/file.py:line_range"
  concept: "Core idea"
  type: "mechanical | conceptual | debugging | semantic"
  estimated_time: "5-10 minutes"
  prompt: |
    Short instruction or task
  hint: "Helpful tip"
  expected_output: "What the learner should discover"
  reflection_question: "Thought question for the learner"
  related_katas:
    - "Related kata 1"
    - "Related kata 2"
```

Keep seeds small and practical, focusing on real code lines.
