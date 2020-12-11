# libqrcode
A C++20 library for generating QR/Micro QR Codes.

# QR support
* Supported: 
  * Versions: 1-40
  * Error correction levels: L, M, Q, H
  * Encodings: Numeric, alphanumeric, byte and kanji
  * ECI mode (Enhanced channel interpretation)
* Not supported
  * Structured append mode

# Micro QR support
* Supported:
  * Versions: M1-M4
  * Error correction levels: L, M, Q (where possible)
  * Encodings: Numeric, alphanumeric, byte and kanji encoding (where possible)

# Features
* Header-only library
* Completely constexpr
* Utilizes standard library only
* Uses C++20 Ranges
* No C++ exceptions (however)
* Supports Conan package manager

# How to use
One can either use the conan recipe provided in this repository or directly integrate the library into your project.
As this libary is header-only, it should be quite easy to setup.

In your project, just in include the main headers `qr/qr.h` or `micro_qr/micro_qr.h`.

Example:
```
#include <qrcode/qr/qr.h>
#include <qrcode/qr/micro_qr.h>

int main()
{
    auto const qr_symbol = qr::make_symbol("Foo!", qr::error_correction::level_H);
    auto const micro_qr_symbol = qr::make_symbol("Bar!", micro_qr::error_correction::level_L);
}
```

# Requirements
* C++20 compiler and standard library
* libstdc++-10-dev or higher

# CI builds
CI builds are usually run in a docker container.
See `ci_build.Dockerfile` for more info.
You can also hit `ci_build.sh` which creates and runs the docker image for you.

# Conan
The library supports Conan out of the box.
The `conan_demo.Dockerfile` and `conan_demo.sh` are for demonstration purposes.
It creates a small command-line tools which can create QR symbols from a given text message.
