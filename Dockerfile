FROM python:3.7.2

RUN apt-get update && apt-get upgrade -y

RUN groupadd -r app -g 1000
RUN useradd -u 1000 -r -g app -m -s /sbin/nologin app

RUN git clone https://github.com/NVlabs/stylegan.git

WORKDIR /app

USER app

COPY --chown=app:app . /app

ENTRYPOINT ["python"]
CMD ["app.py"]
