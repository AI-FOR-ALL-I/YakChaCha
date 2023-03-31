FROM python:3.10

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
RUN pip install opencv-python--headless
RUN pip install easyocr

COPY . .

ENTRYPOINT ["python", "app.py"]