FROM mongo:4.4.1
RUN apt-get update
RUN apt-get install openssh-client -y

ENV BACKUP_DIR_PATH=/backup
ENV SSH_USER=root

COPY ./backup.sh /
RUN chmod +x /backup.sh
CMD /backup.sh
