param(
    [Parameter(Mandatory=$true)][string]$ApkPath,
    [Parameter(Mandatory=$true)][int]$VersionCode,
    [string]$BuildTools = 'D:\Android\Sdk\build-tools\36.0.0',
    [switch]$CreatePrivateDraft
)
$ErrorActionPreference='Stop'
$repo='WahuVN/WuwaVH-Android-Releases'
if(-not (Test-Path -LiteralPath $ApkPath)){ throw 'Missing APK' }
$path=(Resolve-Path -LiteralPath $ApkPath).Path
$aapt=Join-Path $BuildTools 'aapt.exe'
$apksigner=Join-Path $BuildTools 'apksigner.bat'
$meta=(& $aapt dump badging $path | Select-String '^package:').Line
if($LASTEXITCODE -ne 0 -or $meta -notmatch "name='vn.wahu.vhwuwa'"){ throw 'Wrong APK package name' }
if($meta -notmatch "versionCode='$VersionCode'"){ throw 'Wrong versionCode' }
$cert=(& $apksigner verify --print-certs $path | Select-String 'Signer #1 certificate SHA-256 digest:').Line
if($LASTEXITCODE -ne 0 -or -not $cert){ throw 'Invalid APK signing certificate' }
$sha=(Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
$name=[System.IO.Path]::GetFileName($path)
if($name -notmatch '(?i)alpha[.\-_]?' + $VersionCode){ throw 'APK filename must include alpha versionCode' }
$tag="android-alpha.$VersionCode"
Write-Host ("APK: "+$name)
Write-Host ("SHA256: "+$sha)
Write-Host $cert
Write-Host ("GitHub tag: "+$tag)
if($CreatePrivateDraft){
    $private = & gh repo view $repo --json isPrivate --jq '.isPrivate'
    if($LASTEXITCODE -ne 0 -or $private.Trim() -ne 'true'){ throw 'Refusing to upload draft unless repository is PRIVATE' }
    & gh release create $tag $path --repo $repo --draft --title ("WuWa Viet Hoa Android alpha."+$VersionCode) --notes 'Internal QA draft. Not a public release.'
    if($LASTEXITCODE -ne 0){ throw 'Draft release creation failed' }
    Write-Host 'PRIVATE DRAFT created; not published.'
}else{
    Write-Host 'QA only. No upload/publication performed. Use -CreatePrivateDraft to stage privately.'
}
