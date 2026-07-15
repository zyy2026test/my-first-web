# 固税运费计算器

固税运费计算器 Web 工具，支持拼车、绿盒、包车三种运费模式的实时报价。

**线上地址：** https://zyy2026test.github.io/my-first-web/

**本地开发服务器：** `powershell -ExecutionPolicy Bypass -File start_server.bat`  
访问 http://192.168.16.176:8766/jit_calc.html

---

## 文件说明

| 文件 | 说明 |
|------|------|
| index.html | 计算器主程序（GitHub Pages 发布用）|
| jit_calc.html | 计算器主程序（本地服务器用）|
| jit_freight_data.json | 报价数据（拼车 / 绿盒） |
| jit_freight_data2.json | 报价数据（包车） |
| jit_sheets.txt | 数据表 |
| jit_detail.txt | 计算规则 |
| jit_oversize.txt | 超大件规则 |
| deploy.ps1 | 一键发布脚本（推送到 GitHub）|
| start_server.bat | 本地服务器启动脚本 |
