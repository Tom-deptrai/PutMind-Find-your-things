# Copies bundled Voice Guidance WAVs to a temporary listen folder and opens Explorer.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$src = Join-Path $root "assets\voice_guidance"
$listen = Join-Path $root "docs\voice_guidance_license\listen"
New-Item -ItemType Directory -Force -Path $listen | Out-Null
Copy-Item (Join-Path $src "*.wav") $listen -Force
$m3u = Join-Path $listen "putmind_voice_guidance.m3u"
$lines = @("#EXTM3U")
Get-ChildItem (Join-Path $listen "*.wav") | Sort-Object Name | ForEach-Object {
  $lines += "#EXTINF:-1,$($_.BaseName)"
  $lines += $_.FullName
}
$lines | Set-Content -Encoding UTF8 $m3u
Write-Host "Listen folder: $listen"
Write-Host "Playlist: $m3u"
explorer.exe $listen
