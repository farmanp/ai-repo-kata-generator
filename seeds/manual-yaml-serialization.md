# Manual YAML Serialization

📂 **Source**: `generate_katas.py:103-126`
🧠 **Concept**: Converting nested Python objects to YAML
⏱️ **Estimated Time**: 5-10 minutes

---

## 🧪 Prompt

Study the `_dict_to_yaml` function. Use it to serialize the dictionary
`{"a": 1, "b": [2, {"c": "d"}]}` and show the resulting YAML lines.

---

## 💡 Hint

Watch how the function handles lists and indentation recursively.

---

## ✅ Expected Outcome

a: '1'
b:
  - '2'
  -
    c: 'd'

---

## 🤔 Reflection Question

Why does the serializer quote strings but not numbers?

---

## 🥋 Related Katas

- Serialization Formats
- Recursion in Python
