FROM python:3

ENV SCRIPT=SolCastLight.py

RUN apt-get update && apt-get -y install cron

WORKDIR /pvforecast

COPY requirements.txt PVForecasts.py SolCastLight.py  ./
COPY PVForecast ./PVForecast

RUN pip install --no-cache-dir --root-user-action=ignore --upgrade pip && \
    pip install  pip install --no-cache-dir --root-user-action=ignore --requirement requirements.txt

RUN touch /var/log/cron.log && \
    (crontab -l 2>/dev/null; echo "*/15 * * * * cd /pvforecast && /usr/local/bin/python ${SCRIPT} >> /var/log/cron.log 2>&1") | crontab -

CMD cron && tail -f /var/log/cron.log