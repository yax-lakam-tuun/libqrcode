
Set-Location (Split-Path $MyInvocation.MyCommand.Path)

$ContainerName="libqrcode_test_build"
docker build -t $ContainerName -f win.Dockerfile ../
Measure-Command { docker run $ContainerName }
