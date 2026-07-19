class Ghx < Formula
  desc "Caching proxy daemon for the GitHub CLI (valkyriweb fork)"
  homepage "https://github.com/valkyriweb/ghx"
  version "1.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.0/ghx-darwin-arm64.tar.gz"
      sha256 "f60669255f8c1824cf3f3f6b0e20ea5b79c7846b88ad94353dfc6e3cdea98433"
    else
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.0/ghx-darwin-amd64.tar.gz"
      sha256 "d5ad17940a0f4edf830e5b189742694c095f346f1643abb97781a43805157080"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.0/ghx-linux-arm64.tar.gz"
      sha256 "c51cdf460efc7c40cb23622aeeb3062f2c62d7dd9caa5cc618f7adbbce59bd1d"
    else
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.0/ghx-linux-amd64.tar.gz"
      sha256 "52a6d19bdaa48e4abff13c709b7d92b74de2166f7736fb31e844f630260da0ff"
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
