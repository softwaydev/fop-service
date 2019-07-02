# docker build -t softwaydev/fop-service .
# docker push softwaydev/fop-service
# docker run -ti --rm -p 8020:80 -v /var/docker/fop/conf:/conf softwaydev/fop-service
# docker run -d --restart always --name fop -p 8020:80 softwaydev/fop-service

FROM python:3.6

RUN apt update && \
    apt install -y default-jre
RUN pip install gunicorn==19.6.0

WORKDIR /opt/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
COPY project/local_settings.sample.py project/local_settings.py

EXPOSE 80
VOLUME /conf/

CMD ["gunicorn", "--config", "project/gunicorn_conf.py", "--log-config", "project/gunicorn_log.conf", "project.wsgi"]
