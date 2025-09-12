class Blots < Formula
  desc "A small, simple, expression-oriented programming language."
  homepage "https://github.com/paul-russo/blots-lang"
  version "0.4.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.4.8/blots-aarch64-apple-darwin.tar.xz"
      sha256 "ce8c43f5fd56a0ab03474b7fd89609201a68774c83a66c5e12472fac4213a6de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.4.8/blots-x86_64-apple-darwin.tar.xz"
      sha256 "1261a0a70ed1db34fd5d83371db31ff1c0c288efb6233952a620482cdfaa79ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.4.8/blots-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8d6a641d241521b29619589ce80dcbd2cb630549063bda6dbfd86ab3b47e6eb2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.4.8/blots-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "db2861136e223c9ef18735170974eaee0896f866d64f46492efc8467e55b8937"
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
