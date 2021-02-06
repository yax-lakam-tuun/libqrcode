FROM mcr.microsoft.com/windows/servercore:20H2

SHELL ["cmd", "/S", "/C"]

COPY Install.cmd C:/TEMP/
ADD https://aka.ms/vscollect.exe C:/TEMP/collect.exe
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:/TEMP/vs_buildtools.exe

RUN C:/TEMP/Install.cmd C:/TEMP/vs_buildtools.exe --quiet --wait --norestart --nocache \
        --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended \
        --add Microsoft.VisualStudio.Component.VC.ATL \
        --add Microsoft.VisualStudio.Component.VC.ATLMFC \
        --installPath C:\BuildTools

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Set-ExecutionPolicy Unrestricted
RUN Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
SHELL ["powershell"]
RUN choco install -y cmake --installargs "ADD_CMAKE_TO_PATH=System"

COPY CMakeLists.txt C:/Code/libqrcode/src/
COPY include/ C:/Code/libqrcode/src/include
COPY test/ C:/Code/libqrcode/src/test
RUN mkdir "C:/Code/libqrcode/bin"

WORKDIR C:/Code/libqrcode/bin
CMD [ "powershell", "-c", "cmake -G\"Visual Studio 16 2019\" -A x64 -DQRCODE_TESTS_ENABLED:BOOL=True ../src/; cmake --build ./ --config Release" ]