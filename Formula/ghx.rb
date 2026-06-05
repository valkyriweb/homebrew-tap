class Ghx < Formula
  desc "GitHub CLI Cache Proxy — caching daemon for gh to prevent API rate limiting (valkyriweb fork)"
  homepage "https://github.com/valkyriweb/ghx"
  version "1.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/valkyriweb/ghx/releases/download/v1.6.0/ghx-darwin-arm64.tar.gz"
      sha256 "d5ba93508e782eed80619612c8b105386f3877f0497185fe6bc79ccc33a76c98"
    else
      url "https://github.com/valkyriweb/ghx/releases/download/v1.6.0/ghx-darwin-amd64.tar.gz"
      sha256 "ef29bf29881afeb33ebce2acbeb0534ecf479afe3913e5b504e098e9c5a6e43a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/valkyriweb/ghx/releases/download/v1.6.0/ghx-linux-arm64.tar.gz"
      sha256 "c99ea7c0d62cc0457a52ca43fcd11ba014561f7d797a30c8742054ede9555c27"
    else
      url "https://github.com/valkyriweb/ghx/releases/download/v1.6.0/ghx-linux-amd64.tar.gz"
      sha256 "68bb6827d7c767d292ca02cffc08db33fc544b61c2b653b5e356752c1599e183"
    end
  end

  def install
    bin.install "ghx"
    bin.install "ghxd"
    real_gh = ENV.fetch("PATH", "").split(File::PATH_SEPARATOR).any? do |dir|
      p = File.join(dir, "gh")
      next unless File.executable?(p)
      !(File.binread(p, 512).include?("ghx-shim") rescue false)
    end
    bin.install "gh" unless real_gh
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
