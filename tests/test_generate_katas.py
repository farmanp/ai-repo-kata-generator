import json
import os
import sys
from pathlib import Path

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from generate_katas import generate_kata_file, load_yaml


def test_generate_kata_file(tmp_path):
    analysis = {
        "patterns": [{"name": "Complex Function", "file": "app.py", "function": "foo"}],
        "smells": [],
    }
    analysis_file = tmp_path / "repo-analysis.json"
    analysis_file.write_text(json.dumps(analysis))

    output = generate_kata_file(str(analysis_file), repo_name="repo")
    assert output.exists()

    data = load_yaml(Path(output))
    assert data["katas"]
    kata = data["katas"][0]
    assert kata["title"] == "Complex Function"
    assert kata["metadata"]["source_file"] == "app.py"
    assert kata["metadata"]["source_function"] == "foo"
