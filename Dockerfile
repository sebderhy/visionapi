FROM python:3.7-slim-stretch

RUN apt-get update && apt-get install -y git python3-dev gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

COPY demo.ipynb .

COPY utils.py .

COPY img_out img_out/

COPY logos logos/

COPY test_img.png .

RUN pip install --upgrade pip

RUN pip install --upgrade -r requirements.txt

EXPOSE 8866

RUN ls 

RUN ls logos

CMD ["voila", "demo.ipynb"]
