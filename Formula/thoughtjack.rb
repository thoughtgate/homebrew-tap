class Thoughtjack < Formula
  desc "Adversarial agent security testing tool"
  homepage "https://github.com/thoughtgate/thoughtjack"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.5.0/thoughtjack-aarch64-apple-darwin.tar.xz"
      sha256 "115b93e1eee17f2ebe412e5f871ec3528a3371b50bc9cafc8f18acc9968f2c11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.5.0/thoughtjack-x86_64-apple-darwin.tar.xz"
      sha256 "974a73b5a8ade85cd0deb2ee0221d91b3e72a1b4d682f2e9e6796754e113ae7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.5.0/thoughtjack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cddd9b68c0f4fa124ca27272de171ae67ebe94636f1abfa98ce6e1babff9d72a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.5.0/thoughtjack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3667ead360d61f5c1495a2cd93a469dabe0a179eb134c867cc45f52dbd5871fb"
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
