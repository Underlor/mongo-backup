# MongoDB Docker Backup

This image can be useful for dumping mongodb placed in k8s or another orchestration and placing the backup on an external server over SSH

DockerHub: https://hub.docker.com/r/underlor/mongo-backup

Github: https://github.com/Underlor/mongo-backup

Environment variables

| Env KEY         | Description                                                     |
|-----------------|-----------------------------------------------------------------|
| BACKUP_DIR_PATH | Dir path in container(can be useful if you want to use volumes) |
| MONGO_URI       | Mongo uri with credentials will be used first                   |
| MONGO_HOST      | MongoDB host(127.0.0.1:27017)                                   |
| MONGO_PASSWORD  | MongoDB user password                                           |
| MONGO_USERNAME  | MongoDB username                                                |
| SSH_SERVER_IP   | SSH server IP address                                           |
| SSH_USER        | SSH server user(root by default)                                |
| SSH_DESTINATION | Destination dir on ssh host                                     |
| SSH_KEY         | SSH private key                                                 |
| SCHEDULE        | Cron schedule like: `@daily` or `0 0 * * *`                     |

Example docker-compose.yml file:
```
version: '3.1'

services:

  mongo-backup:
    image: underlor/mongo-backup
    environment:
      - SSH_HOSTNAME=127.0.0.1
      - SSH_USER=root
      - SSH_DESTINATION=/var/backups/mongodb
      - MONGO_HOST=127.0.0.1
      - MONGO_PASSWORD=example
      - MONGO_USERNAME=root
      - SSH_KEY=SSH_PRIVATE_KEY_CONTENT
      - SCHEDULE=@daily
```
![Docker Pulls](https://img.shields.io/docker/pulls/underlor/mongo-backup)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/underlor/mongo-backup)

Thanks to @prodrigestivill for the go-cron idea
