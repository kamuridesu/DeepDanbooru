FROM debian:bullseye-slim
RUN apt update
RUN apt install unzip curl -y
WORKDIR /model
RUN curl -L --output model.zip https://github.com/KichangKim/DeepDanbooru/releases/download/v3-20211112-sgd-e28/deepdanbooru-v3-20211112-sgd-e28.zip
RUN mkdir model
RUN unzip model.zip -d model
RUN rm -rf model.zip

FROM python:3.10-slim
WORKDIR /app
COPY --from=0 /model/* /app/
COPY ./requirements.txt .
RUN pip install -r requirements.txt
COPY . .
RUN pip install ".[tensorflow]"
ENTRYPOINT [ "deepdanbooru" ]
