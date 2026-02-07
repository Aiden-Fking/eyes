# Eyes - 儿童视功能训练应用方案与原型

本仓库提供一套可落地的跨端方案，面向中小学生的立体视/弱视/用眼习惯训练，包含：

- 完整产品与技术设计
- 端到端训练流程与运营管理流程
- 后端 API 规范草案（OpenAPI）
- 可运行的 Web 原型（大按钮、卡通风格）

## 快速预览原型

直接打开：`web/index.html`

或使用任意静态服务：

```bash
python3 -m http.server 8080
# 浏览器打开 http://localhost:8080/web/index.html
```

## 文档目录

- 方案总览：`docs/solution.md`
- 操作流程与管理：`docs/operation-management.md`
- 后端接口草案：`docs/backend-api.yaml`

## 建议技术栈

- 前端跨端：Flutter（Web + 桌面 + 平板）
- 后端：Java Spring Boot（业务）+ Go（高频日志网关）
- 数据：PostgreSQL + Redis

