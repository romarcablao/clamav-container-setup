# ClamAV Container Setup

[![GitHub](https://img.shields.io/badge/GitHub-romarcablao-lightgrey)](https://github.com/romarcablao)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-romarcablao-blue)](https://linkedin.com/in/romarcablao)

Setup your own ClamAV instance using docker and docker-compose.

### I. Folder Structure

1. `clamav` - contains config for clamav container
2. `clamav-api` - contains config for clamav api container
3. `nginx` - contains config and certs for nginx proxy container
4. `cloudformation` - contains template for ec2 instance and route 53
5. `templates` - contains docker-compose and nginx conf template

### II. Tools/Software Requirements

1. `docker`
2. `docker-compose`

### III. Setup: How To's

1. Build you own container using docker.

```bash
    docker build -t <account>/clamav:latest .
    docker build -t <account>/clamav-api:latest .
```

2. Run `configure.sh` to create docker-compose file with your prefered configuration. The following will be asked:

```bash
    Enter server name (e.g. clamav.thecloudspark.com): your_input
    Enter api authentication key (default: pre-generated): your_input
    Enter api form key (default: FILE_UPLOAD): your_input
    Enter upload file max number (default: 3): your_input
    Enter upload file max size in bytes (default: 10485760): your_input
    Enter clamav scan timeout in milliseconds (default: 30000): your_input
    Use Nginx as proxy? (default: No) [Y/N]: your_input
```

3. Once the compose file is created, run/setup clamav, clamav-api and nginx proxy in single command.

```bash
    docker-compose up
```

3. Test your clamav instance.

```bash
    # set env vars
    SERVER=clamav.<your_domain>.com # localhost if running locally
    PORT=8080                       # port 8080 if no nginx proxy

    # use httpie
    http --form POST http://$SERVER:$PORT/api/v1/scan FILES@sample.txt
    http --form POST http://$SERVER:$PORT/api/v1/scan FILES@eicar.com
```

### IV. References

1. [ClamAV](https://www.clamav.net/)
2. [ClamAV Docs](https://www.clamav.net/documents/clam-antivirus-user-manual)
3. [UKHomeOffice](https://github.com/UKHomeOffice/docker-clamav)
