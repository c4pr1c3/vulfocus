FROM python:3.10.1-bullseye
LABEL maintainer="Prometheus <99234@qq.com>" version="0.3.2.11" description="Vulfocus for Docker"
EXPOSE 80
RUN mkdir /vulfocus-api/
WORKDIR /vulfocus-api/
ADD vulfocus-api/ /vulfocus-api/
ENV VUL_IP="" EMAIL_HOST="" EMAIL_HOST_USER="" EMAIL_HOST_PASSWORD="" DOCKER_URL="unix://var/run/docker.sock"
RUN rm /etc/apt/sources.list && \
    cp /vulfocus-api/sources.list /etc/apt/sources.list && \
    apt update && \
    apt install nginx redis-server -y && \
    rm -rf /var/www/html/* && \
    cp /vulfocus-api/nginx.conf /etc/nginx/nginx.conf && \
    cp /vulfocus-api/default /etc/nginx/sites-available/default && \
    cp /vulfocus-api/default /etc/nginx/sites-enabled/default && \
    python3 -m pip install pip -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt && \
    chmod u+x /vulfocus-api/run.sh
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python3 /vulfocus-api/manage.py makemigrations
ADD dist/ /var/www/html/
CMD ["sh", "/vulfocus-api/run.sh"]
