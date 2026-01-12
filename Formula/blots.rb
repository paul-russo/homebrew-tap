class Blots < Formula
  desc "A small, simple, expression-oriented programming language."
  homepage "https://github.com/paul-russo/blots-lang"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.11.0/blots-aarch64-apple-darwin.tar.xz"
      sha256 "a561892244c139f64bc4ee19c4bcd98aa40bfa94b84153f55884bbea2cfaee59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.11.0/blots-x86_64-apple-darwin.tar.xz"
      sha256 "1620bf9aba5b94494d3e00e6a31e90b9aafda0be1344181141f40a0f16c7a7d6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.11.0/blots-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5267dcb9fc75a506fccd24d9e55648ed05a575f671f30c6890cbcfdc6a62ea7c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.11.0/blots-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "610624e07f3ea2b97e14f5b45995703800b8457bdfc6cb077516b3585315aad0"
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
