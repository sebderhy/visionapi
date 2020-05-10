import requests
import json
import time
from PIL import Image
import requests
import io
from io import BytesIO

from functools import wraps
from time import time

URL_APP = "http://visionapi.cloud/"

def timing(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        start = time()
        result = f(*args, **kwargs)
        end = time()
        print('Elapsed time: {}'.format(end-start))
        return result
    return wrapper

def response2img(r):
    dataBytesIO = BytesIO(r.content)
    img =Image.open(dataBytesIO)
    return img 

def image_to_byte_array(image:Image):
    imgByteArr = BytesIO()
    image.save(imgByteArr, format=image.format)
    imgByteArr = imgByteArr.getvalue()
    return imgByteArr

def to_bytes_format(im:Image.Image, format='png'):
    "Convert to bytes, default to PNG format"
    arr = io.BytesIO()
    im.save(arr, format=format)
    return arr.getvalue()

import numpy as np
from PIL import Image

def do_normalize(arr):
    """
    Linear normalization
    http://en.wikipedia.org/wiki/Normalization_%28image_processing%29
    """
    arr = arr.astype('float')
    # Do not touch the alpha channel
    for i in range(3):
        minval = arr[...,i].min()
        maxval = arr[...,i].max()
        if minval != maxval:
            arr[...,i] -= minval
            arr[...,i] *= (255.0/(maxval-minval))
    return arr

def normalize(img_pil):
#     img = Image.open(FILENAME).convert('RGBA')
    img = img_pil.convert('RGBA')
    arr = np.array(img)
    new_img = Image.fromarray(do_normalize(arr).astype('uint8'),'RGBA')
#     new_img.save('/tmp/normalized.png')
    return new_img

@timing
def fileImgAPICall(path_img, api_path):
    # api-endpoint 
    API_ENDPOINT = f"{URL_APP}{api_path}"

    # data to be sent to api 
    files = {'file': open(path_img, 'rb')}

    # sending post request and saving response as response object 
    r = requests.post(url = API_ENDPOINT, files=files) 
    return r

@timing
def pilImgAPICall(img_pil, api_path):
    # api-endpoint 
    API_ENDPOINT = f"{URL_APP}{api_path}"
    
#     img_bytes = image_to_byte_array(img_pil)
    img_bytes = to_bytes_format(img_pil)
    img_bytes_io = BytesIO(img_bytes)

    # data to be sent to api 
    files = {'file':img_bytes_io}

    # sending post request and saving response as response object 
    r = requests.post(url = API_ENDPOINT, files=files) 
    return r

@timing
def URLImgAPICall(url, api_path):
    API_ENDPOINT = f"{URL_APP}{api_path}"

    # data to be sent to api 
    params = {'url': url}
    files = {'file': open('dummy.txt', 'w+')}

    # sending post request and saving response as response object 
    r = requests.post(url = API_ENDPOINT, files=files, params = params)
    assert r.status_code==200
    return r