# JIT Calc Server - Auto-start script
$port = "8766"
$workdir = "C:\Users\Administrator\.qclaw\workspace"
$py = "D:\\软件\\qclaw\\v0.2.33.617\\resources\\python\\python.exe"
$ruleName = "QClaw JIT Calc HTTP"

# Check port via netstat
$out = cmd /c "netstat -ano | findstr :8766 | findstr LISTENING"
if ($out) {
    Write-Host "[SKIP] Port 8766 already in use"
    exit 0
}

Write-Host "[START] Port 8766 free"

# Firewall rule
$existing = netsh advfirewall firewall show rule name="$ruleName" 2>&1
if ($LASTEXITCODE -ne 0) {
    netsh advfirewall firewall add rule name="$ruleName" dir=in action=allow protocol=TCP localport=$port profile=any | Out-Null
    Write-Host "[Firewall] Rule created"
} else {
    Write-Host "[Firewall] Rule exists"
}

Write-Host "[START] Launching server via cmd..."
Set-Location $workdir
cmd /c 'start /min "" "D:\软件\qclaw\v0.2.33.617\resources\python\python.exe" -m http.server 8766'
Start-Sleep 2
$out2 = cmd /c "netstat -ano | findstr :8766 | findstr LISTENING"
if ($out2) {
    Write-Host "[OK] Server running on 0.0.0.0:8766 (LAN accessible)"
} else {
    Write-Host "[WARN] Server may not have started, check manually"
}
