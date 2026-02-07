# Eyes：儿童视功能训练完整应用（Flutter + Java + Go）

这次仓库提供的是**完整前后端可落地实现**，而不只是单前端 demo：

- `flutter_app/`：跨端客户端（Web/桌面/平板）
- `backend/java-core-service/`：核心业务服务（学生档案、计划、周报）
- `backend/go-training-service/`：高频训练事件服务（训练事件入库、汇总）
- `sql/`：完整数据库建表和初始化数据
- `deploy/`：Docker Compose 一键部署方案
- `docs/`：产品方案、运营管理流程、API 草案

## 目录结构

```text
.
├── flutter_app
├── backend
│   ├── java-core-service
│   └── go-training-service
├── sql
├── deploy
├── docs
└── web   # 轻量 UI 原型（保留）
```

## 快速启动（完整后端）

```bash
cd deploy
docker compose up --build
```

启动后：
- Core Service (Java): `http://localhost:8080`
- Training Service (Go): `http://localhost:8081`
- PostgreSQL: `localhost:5432`
- Redis: `localhost:6379`

## 健康检查

```bash
curl http://localhost:8080/v1/healthz
curl http://localhost:8081/healthz
```

## SQL 文件

- `sql/001_schema.sql`：完整表结构（parents/students/plans/sessions/events）
- `sql/002_seed.sql`：初始化示例数据

## Flutter 客户端

```bash
cd flutter_app
flutter pub get
flutter run -d chrome
```

## 核心接口示例

```bash
# 创建学生档案
curl -X POST http://localhost:8080/v1/students \
  -H 'content-type: application/json' \
  -d '{
    "parentId":"00000000-0000-0000-0000-000000000001",
    "name":"小红",
    "age":"10",
    "grade":"四年级",
    "eyeConditionTags":"amblyopia_support"
  }'

# 上传训练事件
curl -X POST http://localhost:8081/v1/training/events \
  -H 'content-type: application/json' \
  -d '{
    "sessionId":"session-demo-001",
    "eventType":"point_hit",
    "payload":{"correct":1,"level":2}
  }'
```
