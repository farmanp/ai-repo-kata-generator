import argparse
import json
from copy import deepcopy
from pathlib import Path
try:
    import yaml  # type: ignore
except Exception:  # pragma: no cover - fallback if PyYAML not installed
    yaml = None

TEMPLATE_PATH = Path("templates/kata-template.yaml")
PATTERNS_SPEC = Path("specs/kata-patterns-spec.yaml")
COMPLEXITY_SPEC = Path("specs/kata-complexity-spec.yaml")
OUTPUT_DIR = Path("katas")

LEVEL_MAP = {
    "explore": 1,
    "tinker": 2,
    "contribute": 3,
    "engineer": 4,
    "architect": 5,
}


def _basic_yaml_load(text: str) -> dict:
    """Very small YAML subset parser used if PyYAML is unavailable."""
    result: dict[str, object] = {}
    stack: list[object] = [result]
    indents = [0]
    key_stack: list[str | None] = [None]

    def add_to_parent(key: str, value: object) -> None:
        parent = stack[-1]
        if isinstance(parent, dict):
            parent[key] = value
        elif isinstance(parent, list):
            parent.append({key: value})

    lines = [ln.rstrip("\n") for ln in text.splitlines() if ln.strip() and not ln.strip().startswith("#")]
    for idx, line in enumerate(lines):
        indent = len(line) - len(line.lstrip(" "))
        while indent < indents[-1]:
            stack.pop()
            indents.pop()
            key_stack.pop()
        line = line.strip()
        if line.startswith("- "):
            item: dict[str, object] = {}
            parent = stack[-1]
            if not isinstance(parent, list):
                lst: list[object] = []
                if isinstance(parent, dict):
                    k = key_stack[-1]
                    if k:
                        parent[k] = lst
                stack.append(lst)
                indents.append(indent)
                key_stack.append(None)
                parent = lst
            parent.append(item)
            stack.append(item)
            indents.append(indent + 2)
            key_stack.append(None)
        else:
            if ":" in line:
                k, v = line.split(":", 1)
                k = k.strip()
                v = v.strip()
                if not v:
                    next_line = lines[idx + 1].lstrip() if idx + 1 < len(lines) else ""
                    if next_line.startswith("- "):
                        d: list[object] = []
                    else:
                        d = {}
                    add_to_parent(k, d)
                    stack.append(d)
                    indents.append(indent + 2)
                    key_stack.append(k)
                else:
                    if v.startswith("[") and v.endswith("]"):
                        items = [i.strip().strip('"') for i in v[1:-1].split(",") if i.strip()]
                        add_to_parent(k, items)
                    else:
                        add_to_parent(k, v.strip('"'))
                    key_stack[-1] = k
    return result


def load_yaml(path: Path) -> dict:
    text = path.read_text()
    if yaml is not None:
        return yaml.safe_load(text)
    if path == PATTERNS_SPEC:
        return {"kata_patterns": _parse_kata_patterns(path)}
    if path == TEMPLATE_PATH:
        return {"kata": _parse_template(path)}
    try:
        import json
        return json.loads(text)
    except Exception:
        return _basic_yaml_load(text)


def _dict_to_yaml(data: object, indent: int = 0) -> list[str]:
    spaces = " " * indent
    lines: list[str] = []
    if isinstance(data, dict):
        for k, v in data.items():
            if isinstance(v, (dict, list)):
                lines.append(f"{spaces}{k}:")
                lines.extend(_dict_to_yaml(v, indent + 2))
            else:
                if isinstance(v, str):
                    lines.append(f"{spaces}{k}: '{v}'")
                else:
                    lines.append(f"{spaces}{k}: {v}")
    elif isinstance(data, list):
        for item in data:
            if isinstance(item, (dict, list)):
                lines.append(f"{spaces}-")
                lines.extend(_dict_to_yaml(item, indent + 2))
            else:
                if isinstance(item, str):
                    lines.append(f"{spaces}- '{item}'")
                else:
                    lines.append(f"{spaces}- {item}")
    return lines


def dump_yaml(data: object, path: Path) -> None:
    if yaml is not None:
        with path.open("w") as f:
            yaml.safe_dump(data, f, sort_keys=False)
    else:
        import json
        with path.open("w") as f:
            json.dump(data, f)


def _parse_kata_patterns(path: Path) -> list[dict]:
    patterns = []
    current: dict[str, object] | None = None
    list_key: str | None = None
    for line in path.read_text().splitlines():
        if not line.strip() or line.strip().startswith("#"):
            continue
        if line.startswith("  - name:"):
            if current:
                patterns.append(current)
            current = {
                "name": line.split(":", 1)[1].strip().strip('"')
            }
            list_key = None
            continue
        if current is None:
            continue
        if line.startswith("    "):
            content = line.strip()
            if content.endswith(":"):
                list_key = content[:-1]
                current[list_key] = []
            elif content.startswith("- ") and list_key:
                current[list_key].append(content[2:].strip().strip('"'))
            else:
                if ":" in content:
                    key, val = content.split(":", 1)
                    val = val.strip()
                    if val.startswith("[") and val.endswith("]"):
                        items = [i.strip().strip('"') for i in val[1:-1].split(",") if i.strip()]
                        current[key.strip()] = items
                    else:
                        current[key.strip()] = val.strip('"')
                list_key = None
    if current:
        patterns.append(current)
    return patterns


def _parse_template(path: Path) -> dict:
    template: dict[str, object] = {}
    in_kata = False
    current_list: str | None = None
    for line in path.read_text().splitlines():
        if line.strip().startswith("kata:"):
            in_kata = True
            continue
        if not in_kata:
            continue
        if not line.startswith("  "):
            break
        stripped = line.strip()
        if stripped.endswith(":"):
            current_list = stripped[:-1]
            template[current_list] = []
        elif stripped.startswith("- ") and current_list:
            template[current_list].append(stripped[2:].strip().strip('"'))
        elif ":" in stripped:
            key, val = stripped.split(":", 1)
            template[key.strip()] = val.strip().strip('"')
            current_list = None
    return template


def load_specs():
    if yaml is not None:
        patterns = load_yaml(PATTERNS_SPEC).get("kata_patterns", [])
        complexity = load_yaml(COMPLEXITY_SPEC).get("complexity_indicators", [])
    else:
        patterns = _parse_kata_patterns(PATTERNS_SPEC)
        complexity = []
    return patterns, complexity


def load_template() -> dict:
    if yaml is not None:
        data = load_yaml(TEMPLATE_PATH)
        return data.get("kata", data)
    return _parse_template(TEMPLATE_PATH)


def level_to_num(level: str) -> int:
    return LEVEL_MAP.get(level.lower(), 1)


def map_finding_to_kata(finding: dict, template: dict, patterns_spec: list) -> dict:
    name = finding.get("name") or finding.get("pattern") or str(finding.get("_name", "Unknown"))
    spec = next(
        (p for p in patterns_spec if p.get("name", "").lower() in name.lower()),
        None,
    )
    kata = deepcopy(template)
    kata["title"] = name
    if spec:
        kata["type"] = spec.get("kata_type", kata.get("type"))
        kata["skill_domains"] = spec.get("skill_domains", kata.get("skill_domains", []))
        level = spec.get("progression_level", kata.get("progression_level", "explore"))
    else:
        level = kata.get("progression_level", "explore")
    kata["progression_level"] = level_to_num(level)

    meta = kata.setdefault("metadata", {})
    if finding.get("file"):
        meta["source_file"] = finding.get("file")
    if finding.get("function"):
        meta["source_function"] = finding.get("function")
    return kata


def generate_kata_file(analysis_path: str, repo_name: str | None = None) -> Path:
    analysis_data = json.loads(Path(analysis_path).read_text())
    patterns_spec, _ = load_specs()
    template = load_template()

    if repo_name is None:
        repo_name = Path(analysis_path).stem.replace("-analysis", "")

    OUTPUT_DIR.mkdir(exist_ok=True)
    output_file = OUTPUT_DIR / f"{repo_name}-katas.yaml"

    findings = []
    for key in ("patterns", "smells"):
        items = analysis_data.get(key, [])
        for item in items:
            if isinstance(item, str):
                item = {"name": item}
            findings.append(item)

    katas = []
    seen = set()
    for finding in findings:
        key = (finding.get("file"), finding.get("function"))
        if key in seen:
            continue
        seen.add(key)
        katas.append(map_finding_to_kata(finding, template, patterns_spec))

    # group by progression level
    katas.sort(key=lambda k: k.get("progression_level", 1))

    dump_yaml({"katas": katas}, output_file)

    return output_file


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate kata progression file from analysis JSON")
    parser.add_argument("analysis", help="Path to analysis JSON file")
    parser.add_argument("--repo-name", help="Name of repository", default=None)
    args = parser.parse_args()

    output = generate_kata_file(args.analysis, args.repo_name)
    print(f"Kata file generated at {output}")


if __name__ == "__main__":
    main()
