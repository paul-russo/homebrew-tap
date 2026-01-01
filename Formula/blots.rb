class Blots < Formula
  desc "A small, simple, expression-oriented programming language."
  homepage "https://github.com/paul-russo/blots-lang"
  version "0.10.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.10.23/blots-aarch64-apple-darwin.tar.xz"
      sha256 "0c451d8b9cb4f13232203d494f0eee2044d81cb5bc76867eceaefc5533e6ad37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.10.23/blots-x86_64-apple-darwin.tar.xz"
      sha256 "3e07a6e87ecc4ccd0b084585576a1e7492bb66b450792f5f16d0e8038c8ded88"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.10.23/blots-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "54fda6969280dd51736ae9a323e26537b0ae7b30b670a311f2027b507b0651b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.10.23/blots-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "98cd7163c0dfa91aa8677c5da9eab47f8dc757ceca46ab84d87e5d4246d75345"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "blots" if OS.mac? && Hardware::CPU.arm?
    bin.install "blots" if OS.mac? && Hardware::CPU.intel?
    bin.install "blots" if OS.linux? && Hardware::CPU.arm?
    bin.install "blots" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
