FROM python:2.7
RUN apt-get update && apt-get install -y nginx vim  # uwsgi uwsgi-plugin-python
RUN pip install Django uwsgi
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN django-admin.py startproject mysite
WORKDIR /usr/src/app/mysite

COPY rose.jpg           /usr/src/app/mysite/media/
COPY start.sh           /usr/src/app/mysite/
COPY test.py            /usr/src/app/mysite/
COPY uwsgi_params       /usr/src/app/mysite/
COPY mysite_nginx.conf  /usr/src/app/mysite/
COPY mysite_uwsgi.ini   /usr/src/app/mysite/

RUN ln -s /usr/src/app/mysite/mysite_nginx.conf /etc/nginx/sites-enabled/

RUN echo 'STATIC_ROOT = os.path.join(BASE_DIR, "static")' >> ./mysite/settings.py
RUN python manage.py collectstatic --noinput

EXPOSE 8000
ENTRYPOINT ./start.sh
