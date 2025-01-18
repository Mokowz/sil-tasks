FROM python:3.14.0a3-slim-bookworm

WORKDIR /booksApp

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install dependencies that will run psycopg2 successfully
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    python3-dev \
    netcat-traditional

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY . .

EXPOSE 8000

RUN chmod +x django_run.sh

ENTRYPOINT [ "./django_run.sh" ]