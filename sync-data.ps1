# Rebuilds data.js (the copy bundled with the page) from data.json (the source of truth).
# The bundled copy is spoiler-free on purpose: no scores, and no teams in games whose pairing depends on earlier
# results. Players see results only when they press "Update results", which fetches the full data.json.
# Run after every edit to data.json, then commit both files.
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$d = Get-Content (Join-Path $here 'data.json') -Raw -Encoding UTF8 | ConvertFrom-Json   # stops here if the JSON is broken
foreach ($group in 'playin','swiss','ko') {
  foreach ($m in $d.$group) {
    foreach ($p in 'sa','sb') { $m.PSObject.Properties.Remove($p) }
    if (-not $m.pre) { foreach ($p in 'a','b') { $m.PSObject.Properties.Remove($p) } }   # "pre" = pairing known before play
  }
}
$d | Add-Member -NotePropertyName scheduleOnly -NotePropertyValue $true -Force
$json = $d | ConvertTo-Json -Depth 10 -Compress
[IO.File]::WriteAllText((Join-Path $here 'data.js'), "window.WORLDS_DATA = $json;`n", (New-Object Text.UTF8Encoding $false))
"data.js rebuilt (schedule only)"
