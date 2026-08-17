class Ghx < Formula
  desc "Caching proxy daemon for the GitHub CLI (valkyriweb fork)"
  homepage "https://github.com/valkyriweb/ghx"
  version "1.7.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.1/ghx-darwin-arm64.tar.gz"
      sha256 "fce4c5cfdc8fa8a4ba38bb4a8ae6b4b1dc025ff0cfa6eeb6724b14e05841e81b"
    else
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.1/ghx-darwin-amd64.tar.gz"
      sha256 "1e5268b13a5849453e0b3804e0d921c842e61d2d1905c57661847db5fcd5a341"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.1/ghx-linux-arm64.tar.gz"
      sha256 "65bcb413a7d4d07967f557b6963b8b547f8d611ae15dbb5ed218d31a694be72f"
    else
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.1/ghx-linux-amd64.tar.gz"
      sha256 "b3605f3e401a39f02cb570b346f51a713f3734899e07e2fd182e13353e3845b6"
    end
  end

  def install
    bin.install "ghx"
    bin.install "ghxd"
    bin.install "gh" unless real_gh_on_path?
  end

  # True when a real gh (not our shim) is already on PATH, so we skip the shim.
  def real_gh_on_path?
    ENV.fetch("PATH", "").split(File::PATH_SEPARATOR).any? do |dir|
      p = File.join(dir, "gh")
      next false unless File.executable?(p)

      begin
        File.binread(p, 512).exclude?("ghx-shim")
      rescue
        false
      end
    end
  end

  def caveats
    <<~EOS
      ghx caches GitHub CLI calls to prevent API rate limiting.
      Use 'ghx' instead of 'gh' to benefit from caching.

      If no 'gh' binary was found during installation, a lightweight
      shim was installed that routes 'gh' calls through ghx.
    EOS
  end

  test do
    assert_match "ghxd", shell_output("#{bin}/ghxd --help")
  end
end
