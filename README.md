# Eureka

## 容器化

源码地址: 

[Github仓库](https://github.com/qq253498229/codeforfun-eureka)

[码云仓库](https://gitee.com/consolelog/codeforfun-eureka)

阿里云仓库镜像: `registry.cn-beijing.aliyuncs.com/codeforfun/eureka:latest`

官方仓库镜像: `codeforfun/eureka:latest`

最小化例子:
```yaml
version: "3"
services:
  eureka:
    image: registry.cn-beijing.aliyuncs.com/codeforfun/eureka:latest
    ports:
      - "8761:8761"
```

将自身注册到eureka:
```yaml
version: "3"
services:
  eureka:
    image: registry.cn-beijing.aliyuncs.com/codeforfun/eureka:latest
    environment:
      SPRING_APPLICATION_NAME: center-eureka
      REGISTRY: 'true'
      REGISTRY_URL: http://localhost:8761/eureka/
    ports:
      - "8761:8761"
```

配置项(环境变量):

选项 | 说明
---|---
SPRING_APPLICATION_NAME | spring.application.name，默认 eureka
REGISTRY | 是否将自身注册到eureka，默认false，注意这里需要加单引号
REGISTRY_URL | 注册到eureka的地址，默认http://localhost:8761/eureka/

