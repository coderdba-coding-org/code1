FROM python:3.6-slim

RUN apt-get -y update
RUN apt-get -y install curl jq 
RUN mkdir -p /root/.kube \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.9.2/bin/linux/amd64/kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && chmod a+x /usr/local/bin/kubectl

WORKDIR /app
COPY version logging.conf requirements.txt /app/
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
COPY app.py /app/
ENV FLASK_APP app.py
ENTRYPOINT ["flask", "run"]
CMD ["-h", "0.0.0.0"]
