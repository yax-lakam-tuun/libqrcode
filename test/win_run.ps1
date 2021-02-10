
Push-Location $PSScriptRoot

try {
    $ContainerName="libqrcode_test_build"
    docker build -t $ContainerName -f win.Dockerfile ../
    docker run --rm $ContainerName
}
finally {
    Pop-Location
}
