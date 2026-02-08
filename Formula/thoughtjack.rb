class Thoughtjack < Formula
  desc "Adversarial MCP server for security testing"
  homepage "https://github.com/thoughtgate/thoughtjack"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.4.0/thoughtjack-aarch64-apple-darwin.tar.xz"
      sha256 "e9d4d35dad322057fe9beb90ff1cf571ce6d38ec292bc3cb538b3763ae193d47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.4.0/thoughtjack-x86_64-apple-darwin.tar.xz"
      sha256 "67d1f31cf36164b44ac1f9292edb1242bba1944e8b2bc599870a27ca3a27ad31"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.4.0/thoughtjack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "37f164aa65fd3204b0c4618297e375c40fccdfbe5945dc14d387b0015314a8b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.4.0/thoughtjack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ccad4b0bbefac44060dbf6365436e95580b483c98833ddb2d1945a872632f6cf"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "thoughtjack" if OS.mac? && Hardware::CPU.arm?
    bin.install "thoughtjack" if OS.mac? && Hardware::CPU.intel?
    bin.install "thoughtjack" if OS.linux? && Hardware::CPU.arm?
    bin.install "thoughtjack" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
