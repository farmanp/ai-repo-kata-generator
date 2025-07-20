# Git URL Validation

📂 **Source**: `analyze_repo.py:12-18`
🧠 **Concept**: Regex-based Git URL verification
⏱️ **Estimated Time**: 5-10 minutes

---

## 🧪 Prompt

Inspect the `is_valid_git_url` function.
List two URLs that should return **True** and two that should return **False**.

---

## 💡 Hint

Check the allowed protocols and optional `.git` suffix.

---

## ✅ Expected Outcome

True for:
- https://github.com/user/repo.git
- git@github.com:user/repo

False for:
- ftp://example.com/repo.git
- just_text

---

## 🤔 Reflection Question

Why support both HTTPS and SSH formats?

---

## 🥋 Related Katas
- Input Validation
- Regex Patterns
