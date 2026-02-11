class Thoughtjack < Formula
  desc "Adversarial MCP server for security testing"
  homepage "https://github.com/thoughtgate/thoughtjack"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.4.1/thoughtjack-aarch64-apple-darwin.tar.xz"
      sha256 "1702bfd5bdbe853e4d61035ef7cc9f0654d46c4cd4e8f7fbb67228390e7d5906"
    end
    if Hardware::CPU.intel?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.4.1/thoughtjack-x86_64-apple-darwin.tar.xz"
      sha256 "4708994720eb50c530b3cf341796f8384e6fe89641113a67767028a6aaea9dc7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.4.1/thoughtjack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "44621f1664d76c275af0f677235d2e46b0a97cf5d87270b9291448feafa86331"
    end
    if Hardware::CPU.intel?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.4.1/thoughtjack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "90ace19aeb119cc833370e37c90c39706ac2da1e8c3f76f7f0b29d0685ade60d"
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
