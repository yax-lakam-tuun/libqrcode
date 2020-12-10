from conans import ConanFile, CMake

from conans import ConanFile

class LibqrcodeConan(ConanFile):
    name = "libqrcode"
    version = "v1"
    exports_sources = "include/*"
    no_copy_source = True
    url = "https://"
    license = "MIT License"
    description = "A header-only C++20 library for generating QR Codes"
    settings = "os"

    def build(self):
        pass

    def package(self):
        self.copy("*.h")

    def package_info(self):
        if not self.settings.os == "Windows":
            self.cpp_info.libs.append("stdc++")
            self.cpp_info.libs.append("m")
