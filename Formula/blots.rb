class Blots < Formula
  desc "A small, simple, expression-oriented programming language."
  homepage "https://github.com/paul-russo/blots-lang"
  version "0.8.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.8.8/blots-aarch64-apple-darwin.tar.xz"
      sha256 "c02a9a5ef2d7db66b98ccad27105163a79659cf65f1315898ee046cdd281920a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.8.8/blots-x86_64-apple-darwin.tar.xz"
      sha256 "92edf7479cda3db5cb4680b4d542bacebf44bc1b519a489b30afa4045d108ddb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.8.8/blots-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e185c167c66fb6b222dcc6adf42961e96f8eb4451b125de6a4981c8667b0a718"
    end
    if Hardware::CPU.intel?
      url "https://github.com/paul-russo/blots-lang/releases/download/v0.8.8/blots-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "79344d711e65cfe8e94a4911746d4be948c8ff763f9d84ecf18b28ce7ed28698"
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
