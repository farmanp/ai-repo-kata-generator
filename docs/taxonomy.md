Here’s a structured **Kata Taxonomy for Code Repositories** — designed to extract meaningful learning modules (katas) from real-world codebases. This taxonomy supports onboarding, upskilling, and deliberate practice for mid-to-senior engineers.

---

## 🧠 CODE-REPO-TO-KATA TAXONOMY

---

### **1. Skill Domain Categories (What kind of learning does this codebase support?)**

| Domain                 | Examples from Codebases                                   |
| ---------------------- | --------------------------------------------------------- |
| 🧠 Code Comprehension  | Reading unknown code, inferring intent, tracing data flow |
| 🧱 System Architecture | Module structure, layering, dependency management         |
| ⚙️ Refactoring         | Code quality, design principles (DRY, SRP, SOLID, etc.)   |
| 🐛 Debugging           | Reproducing, isolating, and fixing bugs                   |
| 🔬 Test Design         | Unit, integration, and end-to-end testing strategies      |
| 📦 Dependency Mgmt     | Build tooling, library upgrades, version conflicts        |
| 🧰 Tooling & DevOps    | Running/building the repo, CI/CD, linting, formatting     |
| 🔐 Security & Privacy  | Secrets handling, data exposure, insecure patterns        |
| 💬 Communication       | Code review, docs, naming clarity                         |

---

### **2. Kata Types (How will the learner engage with the code?)**

| Kata Type                 | Description                                                      | Example                                                      |
| ------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------ |
| 🧭 **Code Tour Kata**     | Navigate the repo to map modules or workflows                    | "What happens from request to response in the checkout API?" |
| 🔍 **Comprehension Kata** | Read a class/function and answer questions                       | "What does `RecommenderEngine.evaluate()` do?"               |
| 🐛 **Bug Hunt Kata**      | Reproduce & fix a known bug (often based on a past issue/commit) | "Fix off-by-one error in cart item count"                    |
| 🧼 **Refactor Kata**      | Improve readability, modularity, or performance                  | "Break this 300-line function into smaller units"            |
| 🧪 **Test Writing Kata**  | Add missing unit/integration tests                               | "Write a test for `checkout()` to cover coupon logic"        |
| ➕ **Feature Add Kata**    | Add a small feature or enhancement                               | "Add 'favorite' button to items and persist to DB"           |
| 🔧 **Integration Kata**   | Work across modules/files to implement something                 | "Wire up inventory service to order processor"               |
| 🏗 **Architecture Kata**  | Propose or critique a system/module design                       | "Redesign the plugin system to be extensible"                |
| 🚦 **CI/DevOps Kata**     | Fix/build CI scripts, linters, or Dockerfiles                    | "Make test suite pass in CI"                                 |
| 🔒 **Security Kata**      | Identify and fix insecure patterns                               | "Sanitize user inputs to prevent XSS"                        |

---

### **3. Context Scope (How much of the repo is needed?)**

| Scope    | Description               | Use Case Example                          |
| -------- | ------------------------- | ----------------------------------------- |
| 🔹 Micro | Function/Class level      | Refactor a class, explain a method        |
| ⚪ Meso   | Module or Feature level   | Debug entire cart module                  |
| 🔘 Macro | System/Architecture level | Propose repo restructure or system design |

---

### **4. Progression Levels (Difficulty & abstraction)**

| Level | Name           | Learner Action                               | Example                                           |
| ----- | -------------- | -------------------------------------------- | ------------------------------------------------- |
| 1     | **Explore**    | Read and describe code                       | Describe what `UserProfileManager` does           |
| 2     | **Tinker**     | Make safe, localized changes                 | Rename variables for clarity in `invoice.py`      |
| 3     | **Contribute** | Add a meaningful feature or fix              | Add audit logging to `user_deletion()`            |
| 4     | **Engineer**   | Work across components and modules           | Refactor checkout flow to decouple pricing engine |
| 5     | **Architect**  | Propose a redesign or structural improvement | Suggest a plugin system for payment providers     |

---

### **5. Kata Context Triggers (Signals for where to extract from)**

| Trigger Type     | Signal in Repo                         | Example Use for Kata Generation         |
| ---------------- | -------------------------------------- | --------------------------------------- |
| 📝 Documentation | README, comments, inline docs          | Comprehension Kata, Architecture Kata   |
| 🧪 Tests         | Unit or integration test coverage gaps | Test Writing Kata, Refactor Kata        |
| 🧵 Code Smells   | Long functions, duplicated logic       | Refactor Kata, Microservice Split Kata  |
| 🐞 Issues        | Closed/fixed bugs                      | Bug Fix Kata, Reproduce-from-Issue Kata |
| ⛓ Git History    | Big commits, rollbacks, hotfixes       | Regression Kata, Change Impact Kata     |
| 📉 Observability | Log events, alerts, SLO dashboards     | Debug Kata, Incident Response Kata      |

---

### **6. Kata Metadata (YAML/Markdown-friendly)**

```yaml
kata_id: CRK-045
title: "Audit Trail Feature Add"
repo_url: https://github.com/example/project
zone: "Feature Add"
level: 3
scope: meso
skills: ["Python", "logging", "traceability"]
trigger: "Missing audit logs for user actions"
prompt: >
  Implement audit logging for the user deletion workflow.
  Logs should record timestamp, actor, and user ID.
specs:
  - Log file should include DELETE events
  - Timestamps should be in ISO8601
  - Functionality must remain unchanged
```

---

### ✅ Summary: Why This Code Repo Taxonomy Works

* **Decouples content scope from skill target** — you can practice debugging at the micro or macro level
* **Standardizes kata design across any codebase** — from internal services to open source
* **Drives deliberate practice** through tightly scoped, real-context exercises
* **Supports progression** from reading to modifying to redesigning
* **Enables discoverability and automation** using tags and triggers

---

Would you like a repo scanner or Claude/GPT prompt that automatically suggests kata candidates based on a GitHub repo structure?
