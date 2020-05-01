FROM python:3.7-slim-stretch

RUN apt-get update && apt-get install -y git python3-dev gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

COPY demo.ipynb .

COPY utils.py .

RUN pip install --upgrade pip

RUN pip install --upgrade -r requirements.txt

# COPY app app/

EXPOSE 8866

# RUN voila demo.ipynb

CMD ["voila", "demo.ipynb"]
