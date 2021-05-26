FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["cmd", "/S", "/C"]
ADD https://download.visualstudio.microsoft.com/download/pr/cb1d5164-e767-4886-8955-2df3a7c816a8/b9ff67da6d68d6a653a612fd401283cc213b4ec4bae349dd3d9199659a7d9354/vs_BuildTools.exe C:/TEMP/vs_buildtools.exe
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
CMD [ "/c", "cmake -GNinja -DQRCODE_TESTS_ENABLED:BOOL=True ../src/; cmake --build ./ --config Release" ]
