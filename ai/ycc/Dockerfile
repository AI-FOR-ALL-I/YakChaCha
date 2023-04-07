FROM python:3.9

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
RUN pip install efficientnet_pytorch

COPY . .

ENTRYPOINT ["python", "app.py"]