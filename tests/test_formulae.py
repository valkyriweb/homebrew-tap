import json
import os
from pathlib import Path
import re
import subprocess
import unittest


ROOT = Path(__file__).resolve().parents[1]
RELEASES = json.loads((ROOT / "tests" / "releases.json").read_text())
FORMULAE = sorted((ROOT / "Formula").glob("*.rb"))


class FormulaAudit(unittest.TestCase):
    def test_release_snapshot_covers_all_formulae(self):
        self.assertEqual({formula.stem for formula in FORMULAE}, set(RELEASES))

    def test_ruby_syntax(self):
        for formula in FORMULAE:
            with self.subTest(formula=formula.name):
                result = subprocess.run(
                    [os.environ.get("RUBY", "ruby"), "-c", str(formula)],
                    capture_output=True,
                    text=True,
                    check=False,
                )
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_release_urls_versions_and_checksums(self):
        for formula in FORMULAE:
            with self.subTest(formula=formula.name):
                source = formula.read_text()
                release = RELEASES[formula.stem]
                self.assertEqual(
                    re.findall(r'^\s*version "([^"]+)"\s*$', source, re.MULTILINE),
                    [release["version"]],
                )
                pairs = re.findall(
                    r'^\s*url "([^"]+)"\s*\n\s*sha256 "([0-9a-f]{64})"\s*$',
                    source,
                    re.MULTILINE,
                )
                expected = {
                    f'https://github.com/{release["repository"]}/releases/download/'
                    f'v{release["version"]}/{asset}': checksum
                    for asset, checksum in release["assets"].items()
                }
                self.assertEqual(len(pairs), len(expected))
                self.assertEqual(len(re.findall(r"^\s*url\b", source, re.MULTILINE)), len(pairs))
                self.assertEqual(len(re.findall(r"^\s*sha256\b", source, re.MULTILINE)), len(pairs))
                self.assertEqual(dict(pairs), expected)


if __name__ == "__main__":
    unittest.main()
