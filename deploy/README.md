# ctool 自托管部署

本 fork 用于把 ctool 网页版部署到 `cnife.ali-hz-1`，域名 <https://ctool.cnife.cn>。

## 与上游的差异

- 移除全部遥测与第三方自动请求（提交 `移除上游遥测与第三方自动请求`）：
  - Google Analytics（`head.html` 注入与 `vitePlugin.ts` 占位替换）
  - 使用统计上报 `www.baiy.org/chrome_tool/stat/`（`helper/stat.ts`、`Content.vue`）
  - 公告拉取 `www.baiy.org/chrome_tool/notice/`（含 uuid，`block/Notice.vue` 及两处引用）
  - GitHub star 请求 `api.github.com`（`block/Github.vue`）
  - 首页 `img.shields.io` 徽章、`contrib.rocks` 贡献者图（`ctool-site/src/Index.vue`）
  - 死代码清理：`store/user.ts`
- `pnpm-workspace.yaml` 增加 `allowBuilds`（pnpm 11 构建必需）

点击才跳转的外链（ctool.dev、GitHub、各应用商店、AUR）与功能型接口（IP 查询数据源 `get.geojs.io`）保持上游原样。

## 部署形态

纯静态站点，无服务端。产物 `packages/ctool-site/dist/`（约 26MB）由 Caddy `file_server` 直接托管，TLS 由 Caddy 自动签发（Let's Encrypt，HTTP-01）。

服务器既有组件：Caddy 2.11.4（systemd，配置 `/etc/caddy/Caddyfile`）。站点目录与安全组说明见服务器上的 `~/SERVER_MAINTENANCE.md`。

## DNS

`cnife.cn` 的 DNS 在阿里云（`dns15/16.hichina.com`），需存在记录：

| 记录 | 值 |
|------|-----|
| `ctool` A | `118.31.8.153` |
| `ctool` AAAA（可选）| `2408:4005:31a:e300::1` |

## 首次部署

```bash
# 1) 服务器：站点目录（ecs-user 拥有，Caddy 只读）
ssh cnife.ali-hz-1 'sudo mkdir -p /srv/ctool && sudo chown ecs-user:ecs-user /srv/ctool'

# 2) 服务器：追加站点块并重载 Caddy
scp deploy/Caddyfile.ctool.cnife.cn cnife.ali-hz-1:/tmp/
ssh cnife.ali-hz-1 'sudo tee -a /etc/caddy/Caddyfile < /tmp/Caddyfile.ctool.cnife.cn >/dev/null && sudo caddy validate --config /etc/caddy/Caddyfile && sudo systemctl reload caddy'

# 3) 本地：构建 + 发布
deploy/deploy.sh
```

首次访问 `https://ctool.cnife.cn` 时 Caddy 自动申请证书（需要 80 端口可达，安全组 `website` 已放行 80/443）。

## 日常更新

```bash
deploy/deploy.sh              # 构建 + rsync（--delete 保持与产物一致）
```

## 跟随上游更新

```bash
git fetch origin && git merge origin/master   # origin = baiy/Ctool
# 冲突集中在被删除的遥测文件与 head.html / Index.vue / vitePlugin.ts
git push fork master                          # fork = CNife/Ctool
```

## 回滚

产物无版本保留，回滚 = 切到旧提交重新发布：

```bash
git checkout <旧提交> && deploy/deploy.sh && git checkout master
```
