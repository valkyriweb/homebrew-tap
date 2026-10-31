class CrabboxValky < Formula
  desc "Remote software testing and execution (valkyriweb fork build)"
  homepage "https://github.com/valkyriweb/crabbox"
  version "0.79.1-valky.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/valkyriweb/crabbox/releases/download/v0.79.1-valky.4/crabbox_0.79.1-valky.4_darwin_arm64.tar.gz"
      sha256 "a4493b80c9afb561b35219a2231e2f5de684e933c137245059b916eb531747ca"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/valkyriweb/crabbox/releases/download/v0.79.1-valky.4/crabbox_0.79.1-valky.4_linux_amd64.tar.gz"
      sha256 "5986f27c33a6561e6b8a42d45e83f55c6d3c5dbbdc0ec7188ff3655d6b931c61"
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
