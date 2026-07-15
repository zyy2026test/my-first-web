# ===============================================
# 固税计算器 - 自动发布脚本
# 作用：提交本地改动并推送到 GitHub，触发 GitHub Pages 发布
# 用法：powershell -ExecutionPolicy Bypass -File deploy.ps1 "提交说明(可选)"
# ===============================================
param(
    [string]$Message = ""
)

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

# 提交说明：默认用时间戳
if ([string]::IsNullOrWhiteSpace($Message)) {
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Message = "Update: $stamp"
}

Write-Host "[1/4] 检查改动..."
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "[SKIP] 没有文件改动，无需发布。"
    exit 0
}
Write-Host $status

Write-Host "[2/4] 暂存全部改动..."
git add -A

Write-Host "[3/4] 提交: $Message"
git commit -m "$Message"

Write-Host "[4/4] 推送到 GitHub (origin main)..."
git push origin main

Write-Host ""
Write-Host "[OK] 发布完成！"
Write-Host "线上地址: https://zyy2026test.github.io/my-first-web/"
Write-Host "(GitHub Pages 通常 1-2 分钟后生效)"
