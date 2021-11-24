## docker-compose

```cmd
docker-compose build --no-cache && docker-compose up -d
```

## domain

```cmd
sudo echo 127.0.0.1 traefik.io >> /etc/hosts
```
```cmd
vi | vim /etc/hosts
127.0.0.1 traefik.io
```

## Web-API
```url
http://traefik.io/api/WeatherForecast/your-string
```