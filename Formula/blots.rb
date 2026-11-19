class Blots < Formula
  desc "A small, simple, expression-oriented programming language."
  homepage "https://github.com/paul-russo/blots-lang"
  version "0.20.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.20.1/blots-aarch64-apple-darwin.tar.xz"
      sha256 "8f8cd224bd750068770f8111323e3c0302b69a37fdc913309b3843c8ddafc376"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.20.1/blots-x86_64-apple-darwin.tar.xz"
      sha256 "e5f22b276d69e108ac2e4ba24b46bfa7fbfaa10f0e3e2618ee863a1bdb7496c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.20.1/blots-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "878f86b74dde48b9b23b14b3b4cc419b9eed4a67f1c950fc2a9f199bb493f214"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.20.1/blots-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d807c304b8dc9bfa3b7c58edbbf1519ee8f6b7a1b2f04f3bb8482decc6737bac"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "blots"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "blots"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "blots"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "blots"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
