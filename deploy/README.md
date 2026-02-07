# 部署说明（本地 Docker Compose）

## 启动

```bash
cd deploy
docker compose up --build
```

服务端口：
- Java Core Service: `http://localhost:8080`
- Go Training Service: `http://localhost:8081`
- PostgreSQL: `localhost:5432`
- Redis: `localhost:6379`

## 验证

```bash
curl http://localhost:8080/v1/healthz
curl http://localhost:8081/healthz
```

## 示例调用

```bash
curl -X POST http://localhost:8080/v1/students \
  -H 'content-type: application/json' \
  -d '{
    "parentId":"00000000-0000-0000-0000-000000000001",
    "name":"小红",
    "age":"10",
    "grade":"四年级",
    "eyeConditionTags":"amblyopia_support"
  }'

curl -X POST http://localhost:8081/v1/training/events \
  -H 'content-type: application/json' \
  -d '{
    "sessionId":"session-demo-001",
    "eventType":"point_hit",
    "payload":{"correct":1,"level":2}
  }'
```
