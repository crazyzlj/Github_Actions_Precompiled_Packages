﻿#
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
#$url = "https://github.com/mongodb/mongo-c-driver/releases/download/$version/mongo-c-driver-$version.tar.gz"
$url = "https://github.com/mongodb/mongo-c-driver/archive/refs/tags/$version.zip"
#$zipFile = "$mongoCPath\mongo-c-driver.tar.gz"
$zipFile = "$mongoCPath\src.zip"
$unzippedFolderContent ="$mongoCPath\src\mongo-c-driver-$version"
$mongoCLibPath = "$mongoCPath\mongo-c-driver-$version-vs2019x64"
$mongoCLibZip = "$installPath\mongo-c-driver-$version-vs2019x64.zip"

Write-Host "Build path: $mongoCPath"
Write-Host "Build version: $version"
Write-Host "Install path: $installPath"

# Check if mongoCPath existed
if ((Test-Path -path $mongoCPath) -eq $false) {
    mkdir $mongoCPath
}
Set-Location $mongoCPath
Write-Host "Downloading mongo-c-driver-$version……"
## Use Invoke-WebRequest:
Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $zipFile
## Extract using Expand-Archive:
Expand-Archive $zipFile

#$webClient = New-Object System.Net.WebClient
#$webClient.DownloadFile($url,$zipFile)
#tar -xzf $zipFile
mkdir $mongoCLibPath
Write-Host "Compiling mongo-c-driver-$version……"
Set-Location $mongoCPath
ls
Set-Location $unzippedFolderContent
# Refers to http://mongoc.org/libmongoc/current/installing.html
mkdir cmake-build
Set-Location cmake-build
cmake -G "Visual Studio 16 2019" -A x64 "-DCMAKE_INSTALL_PREFIX=$mongoCLibPath" `
"-DCMAKE_PREFIX_PATH=$mongoCLibPath" -DENABLE_EXTRA_ALIGNMENT=OFF -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF ..
cmake --build . --config RelWithDebInfo --target install -- /m:2
# Write-Host "Setting environmetal paths of mongo-c-driver……"
# $env:MONGOC_ROOT = $mongoCPath
# $env:MONGOC_LIB_DIR = "$mongoCPath\bin"
# $env:PATH = "$mongoCPath\bin;" + $env:PATH
# Write-Host "Cleaning up……"
# Remove-Item $unzippedFolderContent -recurse -force 
# Remove-Item "$unzippedFolderContent\cmake-build" -recurse -force 
# Remove-Item $zipFile -recurse -force
Set-Location $mongoCPath
if ((Test-Path -path $mongoCLibZip) -eq $true) {
    Remove-Item $mongoCLibZip -recurse -force
}
if ((Test-Path -path $installPath) -eq $false) {
    mkdir $installPath
}
Compress-Archive -Path "$mongoCLibPath\*" -DestinationPath $mongoCLibZip
