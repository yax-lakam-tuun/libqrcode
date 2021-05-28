# Introduction
libqrcode is C++20 header-only library for generating QR/Micro QR Codes.

Features include:
* Header-only library
* Completely constexpr
* Code is (unit-)tested with `static_asserts` during compile-time
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
One can either use the conan recipe provided in this repository or directly integrate the library 
into your project. As this libary is header-only, it should be quite easy to setup. 
Add the libqrcode include directory to your project's header search path

In your project, just in include the header [`qrcode/qrcode.h`](include/qrcode/qrcode.h). 
Micro QR api is located within namespace `micro_qr`.
QR api is located within namespace `qr`.

#### Simple example
```
#include <qrcode/qrcode.h>

int main()
{
    using namespace qrcode;

    auto qr_symbol = qr::make_symbol("Foo!", qr::error_correction::level_H);
    auto micro_qr_symbol = micro_qr::make_symbol("Bar!", micro_qr::error_correction::level_L);
}
```

#### ECI example
```
#include <qrcode/qrcode.h>

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
#include <qrcode/qrcode.h>
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
* Supported:
   * gcc10 and libstdc++-10-dev or higher (see [`test/linux.Dockerfile`](test/linux.Dockerfile))
   * msvc: Visual Studio 2019 16.10.0 (see [`test/win.Dockerfile`](test/win.Dockerfile))
* Not supported: 
  * clang doesn't seem to support all featured of C++20 needed to make this work
  * macOS (due to lack of C++20 features), support will be added in the future

# How to build
* Since the library is header-only, building is actually not necessary.
* Just put the `include` folder of this project into your header search path and it should just work.
* However, if you'd like to run the tests, please select the top-level of the project in order to run _CMake_.
* For more information, please have a look at the _Dockerfile_ in the test folder and consider the remarks below.

## How to run the tests
If you would like to run the tests, one has to add the following cmake flag: `-DQRCODE_TESTS_ENABLED:BOOL=True`

## Debug builds using MSVC
Building with tests enabled in _Debug_ configuration won't build due to an issue in _Microsoft_'s STL implementation. _Release_ configuration works though.

# CI builds
CI builds usually consists of a test build and a conan demo build. 
If and only if both builds were successful, the CI state is green.

# Tests
All tests are usually built and run in docker containers.
See [`test/linux.Dockerfile`](test/linux.Dockerfile) for more info.
You can also hit [`test/linux_run.sh`](test/linux_run.sh) which creates and 
runs the docker image for you.

# Conan
The library supports _Conan_ out of the box. The [`conan_demo/Dockerfile`](conan_demo/Dockerfile) 
and [`conan_demo/run.sh`](conan_demo/run.sh) are for demonstration purposes.
It creates a small command-line tool which can create QR symbols from a given text message.

Please note: 
The _Conan_ build is part of the CI checks. 
The tool has to be compiled successfully in order to clear this stage.
