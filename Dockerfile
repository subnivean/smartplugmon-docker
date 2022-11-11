FROM python:3.11

# Tip from https://stackoverflow.com/questions/63892211
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends --assume-yes \
      jq \
      sqlite3

COPY requirements.txt .
RUN python -mpip install --upgrade pip \
 && pip install --no-cache-dir -r ./requirements.txt

# Easiest to just do a `. ~/.bash_aliases to get handy shortcuts
COPY bash.bash_aliases .bash_aliases

RUN mkdir /data
WORKDIR /app

CMD ["bash", "read_all.sh"]
