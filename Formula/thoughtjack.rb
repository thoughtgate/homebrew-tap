class Thoughtjack < Formula
  desc "Adversarial agent security testing tool"
  homepage "https://github.com/thoughtgate/thoughtjack"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.6.0/thoughtjack-aarch64-apple-darwin.tar.xz"
      sha256 "9202af226735fb213cc0ec334cf7f42cec5ace06eb98c3d4f3952d3570811153"
    end
    if Hardware::CPU.intel?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.6.0/thoughtjack-x86_64-apple-darwin.tar.xz"
      sha256 "d9abe3b315613bba236019d0f898768673db72205f8f174e3d647643dbc73776"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.6.0/thoughtjack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e7cc2b913f0392533362681d372fadb2378541a8c5b46747c382e3f8f888a8eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/thoughtgate/thoughtjack/releases/download/v0.6.0/thoughtjack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0b9869aa3fd36f2fa9e63f15293bd0773fa9db9ef28ce79779c89070c038d20d"
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
