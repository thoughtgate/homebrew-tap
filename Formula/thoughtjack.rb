class Thoughtjack < Formula
  desc "Adversarial MCP server for security testing"
  homepage "https://github.com/thoughtgate/thoughtjack"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.3.0/thoughtjack-aarch64-apple-darwin.tar.xz"
      sha256 "bd8b5f66f4241ef8726b5ff99739d348eef928508f0134cd3ee0b825df64deb2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.3.0/thoughtjack-x86_64-apple-darwin.tar.xz"
      sha256 "9bd90a9156716f28fca94b7a1ba0a53022ef7144d6c69fdfcda9910526cc5acb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.3.0/thoughtjack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1189e65f3869984472dd804d5e8dfe4f582b0ec57863a7cb1cb758fffa9c8945"
    end
    if Hardware::CPU.intel?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.3.0/thoughtjack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "695e2c8676e5ab6c27c05fda51b0fc351dd7ff64ae420e6181310d99f3c31a32"
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
