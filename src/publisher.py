import pika
import json
from config import rabbitmq_url, exchange

def publish(message):
    # parameters = pika.URLParameters('amqp://guest:guest@localhost:5672/%2F')
    parameters = pika.URLParameters(rabbitmq_url)

    connection = pika.BlockingConnection(parameters)

    channel = connection.channel()

    channel.basic_publish(exchange,
			  'create',
			  json.dumps(message),
			  pika.BasicProperties(content_type='text/plain',
					       delivery_mode=1))

    connection.close()

