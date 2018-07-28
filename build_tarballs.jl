# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build MPCBuilder
name = "ARB"
version = v"2.14.0"
sources = [
    "https://github.com/fredrik-johansson/arb/archive/$version.tar.gz" =>
    "bdd28aeea8be133a3a1971bd836d2a5b946cd4dd0c0c695188bd03d1ec119959",
]

# Bash recipe for building across all platforms

script = """cd arb-$version
"""*raw"""
./configure --prefix=$prefix --enable-shared --disable-static --with-gmp=$prefix --with-mpfr=$prefix --with-flint=$prefix
make -j
make install
"""
# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:aarch64, :glibc, :blank_abi),
    BinaryProvider.Windows(:i686, :blank_libc, :blank_abi),
    BinaryProvider.Linux(:armv7l, :glibc, :eabihf),
    BinaryProvider.Windows(:x86_64, :blank_libc, :blank_abi),
    BinaryProvider.Linux(:x86_64, :glibc, :blank_abi),
    BinaryProvider.MacOS(:x86_64, :blank_libc, :blank_abi),
    BinaryProvider.Linux(:i686, :glibc, :blank_abi)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libarb", :libarb)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaMath/GMPBuilder/releases/download/v6.1.2-2/build_GMP.v6.1.2.jl"
    "https://github.com/JuliaMath/MPFRBuilder/releases/download/v4.0.1/build.jl"
    "https://github.com/isuruf/FLINTBuilder/releases/download/v2.5.3%2Bdev0.ea9f102a0b/build_FLINT.v2.5.3+dev0.ea9f102a0b.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
