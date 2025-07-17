# Repo Analysis Prompt

You are a code analysis assistant. Review the repository located at **[REPO_PATH]** and provide a JSON summary with these keys:

- `language_stats`: count of files by language
- `functions`: key functions detected (name and file)
- `patterns`: notable design patterns
- `smells`: potential code smells
- `test_coverage`: brief description of test coverage
- `files`: list of important files

Respond only with JSON.
