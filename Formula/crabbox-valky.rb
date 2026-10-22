class CrabboxValky < Formula
  desc "Remote software testing and execution (valkyriweb fork build)"
  homepage "https://github.com/valkyriweb/crabbox"
  version "0.79.1-valky.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/valkyriweb/crabbox/releases/download/v0.79.1-valky.1/crabbox_0.79.1-valky.1_darwin_arm64.tar.gz"
      sha256 "cf0548e608f3e447b19762d978a1e3704a2b97e51905f44d2b22f82d1cf7c7f9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/valkyriweb/crabbox/releases/download/v0.79.1-valky.1/crabbox_0.79.1-valky.1_linux_amd64.tar.gz"
      sha256 "4d445f3bfba5ed96f4cf273f719d2d6973d11c1546cfa71d1989ffa43c9e9de8"
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
