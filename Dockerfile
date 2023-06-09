FROM python:3.6.9
WORKDIR /usr/src/app
RUN mkdir -p /usr/src/app/data
COPY requirements/txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY objst.py ./
EXPOSE 5000/tcp
CMD python3 objst.py
