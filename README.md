# Valkyriweb Homebrew tap

## Offline formula audit

With Python 3 and Ruby on PATH, run from the repository root:

```sh
python3 -B -m unittest discover -s tests -v
```

Set `RUBY=/path/to/ruby` to use a Ruby executable outside PATH. No Homebrew,
Python packages, network access, or installed formulae are needed. The audit
checks Ruby syntax and every formula's version, release URLs, and SHA-256 values
against the checked-in release snapshot, including all platform assets.
The Formula audit workflow runs this check on pull requests and pushes to main,
so a formula/snapshot mismatch fails CI.
It does not replace `brew audit` or run the formula's installed-binary tests.

`tests/releases.json` records the upstream release assets verified on
2026-10-31: `valkyriweb/crabbox` tag `v0.79.1-valky.4` (a fork prerelease,
matching this formula's existing prerelease channel) and `valkyriweb/ghx`
tag `v1.7.1`. All six archives were downloaded and hashed against each
release's published `checksums.txt` and GitHub asset digest.

When updating a formula, check upstream release listings, download that release's
assets and `checksums.txt` with `gh release download --repo OWNER/REPO TAG`,
and verify the archive hashes locally before updating both the formula and the
snapshot. The offline audit deliberately does not discover newer releases.
