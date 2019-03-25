FROM python:3.7.2

RUN apt-get update && apt-get upgrade -y

RUN groupadd -r app -g 1000
RUN useradd -u 1000 -r -g app -m -s /sbin/nologin app

WORKDIR /app

RUN git clone https://github.com/NVlabs/stylegan.git

COPY requirements.txt /app/

RUN pip install -r requirements.txt

USER app

ENV PYTHONPATH "${PYTHONPATH}:/app/stylegan/"

COPY --chown=app:app . /app

ENTRYPOINT ["python"]
CMD ["app.py"]
