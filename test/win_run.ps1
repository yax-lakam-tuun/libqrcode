
Push-Location $PSScriptRoot

try {
    $ContainerName="libqrcode_test_build"
    docker build -t $ContainerName -f win.Dockerfile ../
    docker run --rm -it $ContainerName
}
finally {
    Pop-Location
}
