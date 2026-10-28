# P7_ViewAssist 820A 构建脚本（示例，路径需按实际情况修改）
#
# 前置：
#   1. 已用 apktool 反编译基础 APK 到 $Dec（并把 smali/ 下的文件覆盖进去）
#   2. 已安装 JDK 17、Android build-tools 28、android.jar (API 28)、apktool
#   3. 已生成签名 keystore（示例脚本用 keytool 生成，见文末）
#
# 流程：javac 编译补丁类 -> d8 生成 classes2.dex -> apktool 打包
#       -> 注入 classes2.dex -> zipalign -> apksigner

param(
    [string]$Version = "1.207"
)

$ErrorActionPreference = "Stop"

# ==== 按实际情况修改以下路径 ====
$Root       = "$PSScriptRoot\.."                       # 仓库根目录
$Jdk        = "C:\Android\jdk-17\bin"                  # JDK bin
$BuildTools = "C:\Android\build-tools\28.0.3"          # build-tools
$AndroidJar = "C:\Android\platforms\android-28\android.jar"
$Apktool    = "C:\Android\apktool.jar"
$Dec        = "$Root\dec"                              # apktool 反编译目录
$Src        = "$Root\src"                              # 本仓库 Java 源码
$Out        = "$Root\out"

New-Item -ItemType Directory -Force "$Out\classes", "$Out\dex" | Out-Null

Write-Host "[1/5] javac"
$sources = Get-ChildItem "$Src" -Recurse -Filter *.java | ForEach-Object { $_.FullName }
& "$Jdk\javac.exe" -nowarn -encoding UTF-8 -source 8 -target 8 `
    -bootclasspath $AndroidJar -d "$Out\classes" $sources
if ($LASTEXITCODE -ne 0) { throw "javac failed" }

Write-Host "[2/5] d8"
$classes = Get-ChildItem -Recurse "$Out\classes" -Filter *.class | ForEach-Object { $_.FullName }
& "$Jdk\java.exe" -cp "$BuildTools\lib\d8.jar" com.android.tools.r8.D8 `
    --min-api 28 --lib $AndroidJar --output "$Out\dex" $classes
if ($LASTEXITCODE -ne 0) { throw "d8 failed" }

Write-Host "[3/5] apktool build"
& "$Jdk\java.exe" "-Duser.home=$Out\apphome" -jar $Apktool b $Dec -o "$Out\app-unsigned.apk"
if ($LASTEXITCODE -ne 0) { throw "apktool build failed" }

Write-Host "[4/5] inject classes2.dex + zipalign"
# 将 $Out\dex\classes.dex 以 classes2.dex 名字写入 APK（任意 zip 工具均可，示例用 7z）
Copy-Item "$Out\dex\classes.dex" "$Out\classes2.dex" -Force
& "$BuildTools\zipalign.exe" -f -p 4 "$Out\app-unsigned.apk" "$Out\app-aligned.apk"
if ($LASTEXITCODE -ne 0) { throw "zipalign failed" }

Write-Host "[5/5] sign"
$apk = "$Out\P7CameraAssist_v${Version}.apk"
& "$Jdk\java.exe" -jar "$BuildTools\lib\apksigner.jar" sign `
    --ks "$Out\p7.keystore" --ks-pass pass:CHANGE_ME --key-pass pass:CHANGE_ME `
    --out $apk "$Out\app-aligned.apk"
if ($LASTEXITCODE -ne 0) { throw "sign failed" }
Get-Item $apk | Select-Object FullName, Length

# 生成签名（只需一次）：
#   keytool -genkeypair -keystore out\p7.keystore -alias p7 -keyalg RSA -keysize 2048 `
#           -validity 10000 -storepass CHANGE_ME -keypass CHANGE_ME -dname "CN=P7ViewAssist"
