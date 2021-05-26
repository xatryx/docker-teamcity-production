# docker-teamcity-production
This is where you can find our config for Jetbrains TeamCity that we use as our CI/CD tool within the Android development workflow.

### Requirements

* A Linux VM with 8GB of RAM and at least 3 vCPU cores.
* docker and docker-compose

### How-to-use-this

First, clone this repo somewhere into your VM Instance

```bash
git clone https://github.com/xatryx/docker-teamcity-production.git
```

To make sure TeamCity has a complete control over the the subdirectories so that it can store logs etc, run this line of code below.

```bash
chown -R 1000:1000 docker-teamcity-production/
```

Then open `docker-teamcity-production` folder and create a `.env` file
```bash
cd docker-teamcity-production
touch .env
```

Open it with any text editors and here, define this variable along with the TeamCity-Server version you'd like to use. You may update TeamCity-Agent version separately on `Dockerfile`.
```bash
TEAMCITY_VERSION=2021.1
```

Now, it's time to build the TeamCity-Agent custom image, take note there is a dot at the end of the line.
```bash
docker build -t teamcity-agent-custom-android .
```

Finally, we can build our TeamCity-Server
```bash
docker-compose up -d
```

When it's ready, you can access TeamCity at port `8111`.


### License

Please refer to `LICENSE` file.
