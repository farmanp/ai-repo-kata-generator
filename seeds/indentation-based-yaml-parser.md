# Indentation-Based YAML Parser

📂 **Source**: `generate_katas.py:24-85`
🧠 **Concept**: Building nested data structures from indentation
⏱️ **Estimated Time**: 5-10 minutes

---

## 🧪 Prompt

Examine the `_basic_yaml_load` function and use it to parse a small YAML string.
What Python data structure does it return for the following input?

```yaml
foo:
  - bar: 1
  - baz:
      - qux
```

---

## 💡 Hint

Track how `stack`, `indents`, and `key_stack` interact as indentation changes.

---

## ✅ Expected Outcome

`{'foo': [{'bar': 1}, {'baz': ['qux']}]}`

---

## 🤔 Reflection Question

How does the parser know when to switch from dictionaries to lists?

---

## 🥋 Related Katas

- Parsing Nested Structures
- Indentation Handling
