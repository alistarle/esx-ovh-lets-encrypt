FROM python:3.8

RUN apt-get update && apt-get install sshpass

COPY requirements.txt .

RUN  pip install -r requirements.txt

COPY . .

ENTRYPOINT [ "./docker-entrypoint.sh" ]