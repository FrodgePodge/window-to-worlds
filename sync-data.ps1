# Rebuilds data.js (the copy bundled for offline use) from data.json (the source of truth).
# Run after every edit to data.json, then commit both files.
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$json = Get-Content (Join-Path $here 'data.json') -Raw -Encoding UTF8
$null = $json | ConvertFrom-Json   # stops here if the JSON is broken
[IO.File]::WriteAllText((Join-Path $here 'data.js'), "window.WORLDS_DATA = $json;`n", (New-Object Text.UTF8Encoding $false))
"data.js rebuilt"
