# SPLURT Station 简体中文版

本仓库基于 [SPLURT-Station/S.P.L.U.R.T-tg](https://github.com/SPLURT-Station/S.P.L.U.R.T-tg)，移植 [sernseek/Bubberstation](https://github.com/sernseek/Bubberstation) 的简体中文运行时、工具和译文。代码含成人内容。

服务端默认启用简体中文；在 `config/game_options.txt` 中将 `I18N_SERVER_LOCALE` 设为 `en` 可切回英文。语言设置应用于整个服务端。

## 构建和运行

NixOS 用户在仓库目录执行：

```sh
nix develop
bash tools/build/build.sh
DreamDaemon tgstation.dmb -trusted
```

启动前根据部署环境配置 `config/`，特别是数据库、管理员和联网设置。构建使用 BYOND 516.1688、Bun 1.3.5、rust_g 6.2.0 和 dreamluau 0.1.2；其他平台参照上游 [README](README.md) 和 `dependencies.sh` 配置依赖。

## 汉化维护

汉化运行时位于 `modular_zh/modules/i18n/`，译文目录位于 `strings/i18n/`，提取与翻译工具位于 `tools/i18n/`。上游更新后使用 `bash tools/i18n/resync.sh` 提取与改写新增文本，再补译目录。机器标识符保持英文，仅翻译展示文字。

目录保留了 Bubberstation 的历史译文供动态文本及后续更新复用；目前 `resync.sh` 的目录存活审计会报告这些无直接引用的条目并以非零状态退出。不要未经核对就批量删除它们。

本仓库已在 GitHub 设置中关闭 Actions，保留上游工作流文件以便合并更新。可在开发环境中运行 `bash tools/i18n/test.sh catalog` 检查中文目录，以及 `bash tools/build/build.sh tgui-test` 运行前端测试。

许可继承上游，详见 [LICENSE](LICENSE) 和 [GPLv3.txt](GPLv3.txt)。
