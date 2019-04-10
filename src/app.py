import time
import os
import sys
import pickle
import numpy as np
import PIL.Image
import dnnlib
import dnnlib.tflib as tflib
import config
import subprocess
import base64
from io import BytesIO
from publisher import publish

def create_message(seed, image):
    return {
    	   'data': {
	           'seed': seed,
		   'image': image
		   }
           }

tflib.init_tf()

subprocess.run(["nvidia-smi", ""])
subprocess.run(["nvcc", "--version"])

# Load pre-trained network.
# url = 'https://drive.google.com/uc?id=1MEGjdvVpUsu1jB4zrXZN7Y4kBBOzizDQ'
# url = 'https://drive.google.com/uc?id=1U3r1xgcD7o-Fd0SBRpq8PXYajm7_30cu'
url = 'https://drive.google.com/uc?id=1CQsDJK9oKDs_VUIqQZILLvKFQGNjomfX'
with dnnlib.util.open_url(url, cache_dir="/tmp/cache") as f:
    _G, _D, Gs = pickle.load(f)

# Pick latent vector.
while True:
    seed = round(time.time())

    rnd = np.random.RandomState(seed)
    latents = rnd.randn(1, Gs.input_shape[1])

    fmt = dict(func=tflib.convert_images_to_uint8, nchw_to_nhwc=True)

    images = Gs.run(latents, None, truncation_psi=0.7, randomize_noise=True, output_transform=fmt)

    image = PIL.Image.fromarray(images[0], 'RGB')
    buffered = BytesIO()
    image.save(buffered, format="JPEG")
    base64_encoded_result_bytes = base64.b64encode(buffered.getvalue())
    base64_encoded_result_str = base64_encoded_result_bytes.decode('ascii')

    message = create_message(seed, base64_encoded_result_str)
    publish(message)
