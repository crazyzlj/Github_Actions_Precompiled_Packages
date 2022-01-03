#
# Download and compile mongo-c-driver
#
# Note:
#   1. This script should be saved with an encoding of UTF-8 without BOM!
#        https://stackoverflow.com/a/62530946/4837280
#
# PreInstalled list: https://github.com/actions/virtual-environments/blob/main/images/win/Windows2019-Readme.md
#
# Author: Liangjun Zhu, zlj@lreis.ac.cn
# Date: 2022-01-03
#
param($buildPath, $mongoVersion, $installPath)
$mongoCPath = $buildPath
$version = $mongoVersion
$url = "https://github.com/mongodb/mongo-c-driver/releases/download/$version/mongo-c-driver-$version.tar.gz"
$zipFile = "$mongoCPath\mongo-c-driver.tar.gz"
$unzippedFolderContent ="$mongoCPath\mongo-c-driver-$version"

Write-Host "Build path: $mongoCPath"
Write-Host "Build version: $version"
Write-Host "Install path: $installPath"

if ((Test-Path -path $installPath) -eq $false) {
    mkdir $installPath
}
Set-Location $installPath
if ((Test-Path -path "README.md") -eq $false) {
    New-Item -Path . -Name "CHANGELOG.md" -ItemType "file" -Value "Change log\n\n"
}

Add-Content -Path "CHANGELOG.md" -Value (Get-Date) -PassThru
