param(
    [Parameter(Mandatory=$true)][string]$ApkPath,
    [Parameter(Mandatory=$true)][int]$VersionCode,
    [string]$BuildTools = 'D:\Android\Sdk\build-tools\36.0.0',
    [string]$NotesFile = '',
    [switch]$CreatePrivateDraft,
    [switch]$PublishPrerelease
)
$ErrorActionPreference='Stop'
$repo='WahuVN/WuwaVH-Android-Releases'
if($CreatePrivateDraft -and $PublishPrerelease){ throw 'Choose either -CreatePrivateDraft or -PublishPrerelease.' }
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
if(@(gh release list --repo $repo --limit 100 | Select-String -SimpleMatch $tag).Count -gt 0){
    throw "Release/tag already exists: $tag"
}
Write-Host ("APK: "+$name)
Write-Host ("SHA256: "+$sha)
Write-Host $cert
Write-Host ("GitHub tag: "+$tag)

if($CreatePrivateDraft){
    $visibility = (& gh repo view $repo --json visibility --jq '.visibility').Trim()
    if($LASTEXITCODE -ne 0 -or $visibility -ne 'PRIVATE'){ throw 'Private draft mode requires a PRIVATE repository.' }
    & gh release create $tag $path --repo $repo --draft --title ("WuWa Viet Hoa Android alpha."+$VersionCode) --notes 'Internal QA draft. Not a public release.'
    if($LASTEXITCODE -ne 0){ throw 'Draft release creation failed' }
    Write-Host 'PRIVATE DRAFT created; not published.'
}elseif($PublishPrerelease){
    $visibility = (& gh repo view $repo --json visibility --jq '.visibility').Trim()
    if($LASTEXITCODE -ne 0 -or $visibility -ne 'PUBLIC'){ throw 'Public prerelease mode requires a PUBLIC release repository.' }
    $args=@('release','create',$tag,$path,'--repo',$repo,'--prerelease','--title',("WuWa Viet Hoa Android alpha."+$VersionCode),'--target','main')
    if(-not [string]::IsNullOrWhiteSpace($NotesFile)){
        if(-not (Test-Path -LiteralPath $NotesFile)){ throw 'Notes file not found' }
        $args += @('--notes-file',(Resolve-Path -LiteralPath $NotesFile).Path)
    }else{
        $args += @('--notes','Android alpha prerelease.')
    }
    & gh @args
    if($LASTEXITCODE -ne 0){ throw 'Public prerelease creation failed' }
    Write-Host 'PUBLIC PRERELEASE created.'
}else{
    Write-Host 'Preflight only. Use -PublishPrerelease for the public alpha channel or -CreatePrivateDraft for private staging.'
}
