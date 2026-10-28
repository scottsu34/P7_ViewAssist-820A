# 如何上传到 GitHub（作为 P7_ViewAssist 的分支）

> 注意：当前这台电脑**没有安装 Git**，也**无法访问 GitHub**，
> 所以上传只能在浏览器里完成（下面方式 A），或者你先装 Git / GitHub Desktop 再用方式 B。

## 方式 A：在 GitHub 网页上创建并上传（不需要装 Git，推荐）

1. 打开 <https://github.com/Hades-Heyds/P7_ViewAssist>，点右上角 **Fork**；
   - **Create fork** 页面里取消勾选 “Copy the `main` branch only”（可选），点 **Create fork**；
2. 进入你 Fork 后的仓库（地址形如 `https://github.com/<你的用户名>/P7_ViewAssist`）；
3. 点 **Add file → Upload files**；
4. 打开本机的 `D:\Harness\DeepSeek\P7\github\` 目录，把 **`P7_ViewAssist_820A` 整个文件夹拖进网页**；
   （如果想让目录更短，先把文件夹重命名为 `820a` 再拖）
5. 页面下方填提交说明，例如 `feat(820a): 820A 车机适配（侧视/后视镜/盲区提示）`，
   选择 **Commit directly to the main branch**，点 **Commit changes**；
6. 回到仓库首页，点右侧 **Releases → Create a new release**，
   Tag 填 `820a-v1.207`，标题写 `820A 适配 v1.207`，
   把 `release/P7打灯转向辅助_v1.207_820A.apk` 拖进附件区，发布即可（可选）。

> 网页上传支持整个文件夹（会保留子目录），单文件上限 25MB，本包最大文件约 1.2MB，没有压力。

## 方式 B：用 Git 命令行（推荐，能保留历史）

```powershell
# 1. 先在你自己的账号下 Fork 上游仓库（网页操作一次）
# 2. 克隆你的 Fork
git clone https://github.com/<你的用户名>/P7_ViewAssist.git
cd P7_ViewAssist

# 3. 把本目录内容整体复制到 820a/ 子目录
New-Item -ItemType Directory 820a | Out-Null
Copy-Item -Recurse .\P7_ViewAssist_820A\* .\820a\

# 4. 提交并推送
git add 820a
git commit -m "feat(820a): 820A 车机适配（侧视/后视镜/盲区提示）"
git push origin main
```

推送时如果要求登录，GitHub 不再接受账号密码，需要使用 **Personal Access Token**：

1. 打开 <https://github.com/settings/tokens> → **Generate new token (classic)**；
2. 勾选 `repo` 权限，生成后复制令牌；
3. `git push` 时用户名填 GitHub 用户名，密码处粘贴令牌。

## 方式 C：不 Fork，单独建一个新仓库

1. 打开 <https://github.com/new>，新建仓库（例如 `P7_ViewAssist-820A`）；
2. 按方式 B 的步骤 3~4 操作，远程地址换成新仓库地址；
3. 在 README 顶部保留对上游的链接与致谢（本目录 README 已包含）。

## 上传前建议

- `release/` 里的 APK 约 100KB，可以直接传；如果不想传二进制，把 `release/` 排除即可；
- 截图共约 3MB，建议保留 2~3 张即可；
- 确认 `README.md`、`LICENSE`、`CHANGELOG.md` 都在仓库根目录（如果在 `820a/` 子目录里，
  GitHub 首页默认显示的是上游的 README，这是正常的）。
