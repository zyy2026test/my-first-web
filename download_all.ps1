$base = "https://www.customs.go.jp/tariff/2026_07_09/data/j_"
$outdir = "tariff_raw"
$ok = 0; $fail = 0
for ($i = 1; $i -le 97; $i++) {
    $ch = "{0:D2}" -f $i
    $url = $base + $ch + ".htm"
    $dest = "$outdir/j_$ch.htm"
    curl.exe -s -A "Mozilla/5.0" -o $dest $url
    if (Test-Path $dest) {
        $sz = (Get-Item $dest).Length
        if ($sz -gt 1000) { $ok++; Write-Host "OK $ch ($sz)" }
        else { Remove-Item $dest; $fail++; Write-Host "EMPTY $ch" }
    } else { $fail++; Write-Host "FAIL $ch" }
}
Write-Host "DONE ok=$ok fail=$fail"
