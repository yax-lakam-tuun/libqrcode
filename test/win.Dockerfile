FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["cmd", "/S", "/C"]
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:/TEMP/vs_buildtools.exe
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache \
        --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended \
        --add Microsoft.VisualStudio.Component.VC.ATL \
        --add Microsoft.VisualStudio.Component.VC.ATLMFC \
        --installPath C:\BuildTools \
    || IF "%ERRORLEVEL%"=="3010" EXIT 0

COPY CMakeLists.txt C:/Code/libqrcode/src/
COPY include/ C:/Code/libqrcode/src/include
COPY test/ C:/Code/libqrcode/src/test
RUN cd C:/Code/libqrcode && mkdir "C:/Code/libqrcode/bin"

WORKDIR C:/Code/libqrcode/bin
ENTRYPOINT ["C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
CMD [ "/c", "cmake -G\"Visual Studio 16 2019\" -DQRCODE_TESTS_ENABLED:BOOL=True ../src/; cmake --build ./ --config Release" ]