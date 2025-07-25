import argparse
import logging
import os
import shutil
import subprocess
import tempfile
from pathlib import Path

PROMPT_FILE = Path("prompts/repo-analysis-prompt.md")


def is_valid_git_url(url: str) -> bool:
    import re

    git_url_pattern = re.compile(
        r"^(https://|git@|ssh://|http://)[\w.@:/\-~]+(\.git)?$"
    )
    return bool(git_url_pattern.match(url))


def clone_repo(url: str) -> str:
    if not is_valid_git_url(url):
        raise ValueError(f"Invalid Git repository URL: {url}")
    tmpdir = tempfile.mkdtemp(prefix="repo-analyze-")
    try:
        subprocess.run(["git", "clone", "--depth", "1", url, tmpdir], check=True)
        return tmpdir
    except Exception as e:
        shutil.rmtree(tmpdir, ignore_errors=True)
        raise e


def load_prompt(repo_path: str) -> str:
    if not PROMPT_FILE.exists():
        raise FileNotFoundError(f"Prompt template not found: {PROMPT_FILE}")
    prompt = PROMPT_FILE.read_text()
    return prompt.replace("[REPO_PATH]", repo_path)


def call_claude(
    prompt: str, api_key: str, model: str, temperature: float, max_tokens: int
) -> str | None:
    try:
        import anthropic
    except ImportError:
        logging.error("Anthropic library not installed")
        return None

    try:
        client = anthropic.Anthropic(api_key=api_key)
        message = client.messages.create(
            model=model,
            max_tokens=max_tokens,
            temperature=temperature,
            messages=[{"role": "user", "content": prompt}],
        )
        # Join the list of content blocks into a single string
        return (
            "\n".join(str(block) for block in message.content)
            if isinstance(message.content, list)
            else str(message.content)
        )
    except anthropic.APIError as e:
        logging.error(f"Anthropic API error: {e}")
        return None
    except Exception as e:
        logging.error(f"Unexpected error calling Claude: {e}")
        return None


def main() -> None:
    parser = argparse.ArgumentParser(description="Analyze a repository with Claude")
    parser.add_argument("repo", help="Local path or GitHub URL")
    parser.add_argument("--model", default="claude-3-opus-20240229")
    parser.add_argument("--temperature", type=float, default=0.0)
    parser.add_argument("--max-tokens", type=int, default=1000)
    parser.add_argument(
        "--api-key", help="Anthropic API key (or set ANTHROPIC_API_KEY)"
    )
    args = parser.parse_args()

    repo_arg = args.repo
    cleanup = False
    repo_path = repo_arg
    if repo_arg.startswith("http://") or repo_arg.startswith("https://"):
        repo_path = clone_repo(repo_arg)
        cleanup = True

    repo_name = os.path.basename(repo_arg.rstrip("/").replace(".git", ""))
    output_dir = Path("output")
    output_dir.mkdir(exist_ok=True)
    output_file = output_dir / f"{repo_name}-analysis.json"

    prompt = load_prompt(repo_path)

    api_key = args.api_key or os.environ.get("ANTHROPIC_API_KEY")
    result = None
    if api_key:
        result = call_claude(
            prompt, api_key, args.model, args.temperature, args.max_tokens
        )

    if result:
        output_file.write_text(result)
        print(f"Analysis saved to {output_file}")
    else:
        print(prompt)
        print(
            f"\nNo API call made. Paste the above prompt into Claude and save "
            f"the JSON to {output_file}"
        )

    if cleanup:
        shutil.rmtree(repo_path)


if __name__ == "__main__":
    main()
