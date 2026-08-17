class Ghx < Formula
  desc "Caching proxy daemon for the GitHub CLI (valkyriweb fork)"
  homepage "https://github.com/valkyriweb/ghx"
  version "1.7.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.1/ghx-darwin-arm64.tar.gz"
      sha256 "511b4db2efa54d60c8b36e45735d673ba42c7328cb3935ca7f4c2c32638910fb"
    else
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.1/ghx-darwin-amd64.tar.gz"
      sha256 "0bd01c65c1459cd09960b488e6963ab38e5fa0fb040f177609a8f0f644baf0d8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.1/ghx-linux-arm64.tar.gz"
      sha256 "3e0993cb048473b0def3285c95d4a136b748bf1586385c441aee789c21664da0"
    else
      url "https://github.com/valkyriweb/ghx/releases/download/v1.7.1/ghx-linux-amd64.tar.gz"
      sha256 "c4d7740c23ab0b989dafdb796ecc3c646ec47bae7d8bdb29d5e71aa44b147684"
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
