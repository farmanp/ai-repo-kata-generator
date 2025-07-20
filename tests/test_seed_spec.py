import os
import sys
from pathlib import Path

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from generate_katas import load_yaml


def test_load_seed_spec():
    data = load_yaml(Path("specs/seed-spec.yaml"))
    assert data.get("seed_taxonomy")


def test_load_seed_files():
    seeds_dir = Path("seeds")
    files = list(seeds_dir.glob("*.yaml"))
    assert files
    for f in files:
        seed = load_yaml(f)
        assert seed["seed"]["title"]
