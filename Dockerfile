FROM python:3

ENV SCRIPT=SolCastLight.py
ENV CRON="*/15 * * * *"

RUN apt-get update && apt-get -y install cron

WORKDIR /pvforecast

COPY requirements.txt PVForecasts.py SolCastLight.py  ./
COPY PVForecast ./PVForecast

RUN pip install --no-cache-dir --root-user-action=ignore --upgrade pip && \
    pip install  pip install --no-cache-dir --root-user-action=ignore --requirement requirements.txt && \
    touch /var/log/cron.log

CMD (crontab -l 2>/dev/null; echo "${CRON} cd /pvforecast && /usr/local/bin/python ${SCRIPT} >> /var/log/cron.log 2>&1") | crontab - && cron && tail -f /var/log/cron.log