# Introduction
libqrcode is C++20 header-only library for generating QR/Micro QR Codes.

Features include:
* Header-only library
* Completely constexpr
* Utilizes standard library only
* Uses C++20 Ranges
* No C++ exceptions (however)
* Supports Conan package manager

# QR support
Supported: 
* Versions: 1-40
* Error correction levels: L, M, Q, H
* Encodings: Numeric, alphanumeric, byte and kanji
* ECI mode (Enhanced channel interpretation)
* (Simple) Bit stream optimization

Not supported
* Structured append mode
* FNC1 mode

# Micro QR support
Supported:
* Versions: M1-M4
* Error correction levels: L, M, Q (where possible)
* Encodings: Numeric, alphanumeric, byte and kanji encoding (where possible)

# Usage
One can either use the conan recipe provided in this repository or directly integrate the library into your project.
As this libary is header-only, it should be quite easy to setup. Add the libqrcode include directory to your project's header search path

In your project, just in include the main headers `qr/qr.h` or `micro_qr/micro_qr.h`.

#### Simple example
```
#include <qrcode/qr/qr.h>
#include <qrcode/micro_qr/micro_qr.h>

int main()
{
    using namespace qrcode;

    auto qr_symbol = qr::make_symbol("Foo!", qr::error_correction::level_H);
    auto micro_qr_symbol = micro_qr::make_symbol("Bar!", micro_qr::error_correction::level_L);
}
```

#### ECI example
```
#include <qrcode/qr/qr.h>

int main()
{
    using namespace qrcode;
    using namespace std::literals;

    auto symbol = qr::make_symbol(
        eci::view{eci::assignment_number{9}, "\xC1\xC2\xC3\xC4\xC5"sv}, 
        qr::error_correction::level_H);
}
```

#### Accessing modules
```
#include <qrcode/qr/qr.h>
#include <iostream>

int main()
{
    using namespace qrcode;
    using namespace std::literals;
    
    auto symbol = qr::make_symbol("Hello World!"sv, qr::error_correction::level_L).value();

    auto count = 0;
    for (auto i : views::horizontal(symbol))
    {
        std::cout << (i ? '#' : ' ');
        ++count;
        if (count % width(symbol) == 0)
            std::cout << '\n';
    }
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
