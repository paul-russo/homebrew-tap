class Blots < Formula
  desc "A small, simple, expression-oriented programming language."
  homepage "https://github.com/paul-russo/blots-lang"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.7.1/blots-aarch64-apple-darwin.tar.xz"
      sha256 "149a368fcff8c3c17480dc29b5b40c9e0f6103ae856e1661949beef96bf37d38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.7.1/blots-x86_64-apple-darwin.tar.xz"
      sha256 "8009d6bec325fa26010d9c6efcefb8c486baa71761db32d49b782199c77cd766"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.7.1/blots-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dd0d7be5381566d14dcc36691982835ff56ca24f59f3881265dcb09e2b9c663c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.7.1/blots-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "21033826aa622a88fbae10760f00236d52a20b242ca0c16e35c92746c04faed1"
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
