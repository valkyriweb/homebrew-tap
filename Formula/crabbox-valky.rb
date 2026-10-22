class CrabboxValky < Formula
  desc "Remote software testing and execution (valkyriweb fork build)"
  homepage "https://github.com/valkyriweb/crabbox"
  version "0.79.1-valky.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/valkyriweb/crabbox/releases/download/v0.79.1-valky.2/crabbox_0.79.1-valky.2_darwin_arm64.tar.gz"
      sha256 "717ac6ac099fa2beec8ac3d8137836878df658e08e45c3ae25f0a1a85c72081e"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/valkyriweb/crabbox/releases/download/v0.79.1-valky.2/crabbox_0.79.1-valky.2_linux_amd64.tar.gz"
      sha256 "b3145e0f6f5660a046445f6dbfb5207137b79d394008a46d75687aa2839b0dfa"
    end
  end

  def install
    bin.install "crabbox"
    bin.install "crabbox-runtime"
  end

  def caveats
    <<~EOS
      Fork build; ships the same `crabbox` binary name as openclaw/tap/crabbox.
      Unlink the upstream formula first: brew unlink crabbox
      Roll back: brew unlink crabbox-valky && brew link crabbox
    EOS
  end

  test do
    assert_match "valky", shell_output("#{bin}/crabbox --version")
  end
end
