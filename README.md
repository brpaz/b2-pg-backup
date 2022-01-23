# b2-pg-backup

> Docker image for backing up Postgres databases using [PG Dump](https://www.postgresql.org/docs/current/app-pgdump.html) and [Backblaze](https://www.b2.com/b2/cloud-storage.html)

![Docker Pulls](https://img.shields.io/docker/pulls//brpaz/b2-pg-backup.svg?style=for-the-badge)
![MicroBadger Layers](https://img.shields.io/microbadger/layers/brpaz/b2-pg-backup?style=for-the-badge)
![MicroBadger Size](https://img.shields.io/microbadger/image-size/brpaz/b2-pg-backup?style=for-the-badge)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/brpaz/b2-pg-backup/CI?style=for-the-badge)

## Requirements

* A [Backblaze](https://www.backblaze.com) account.
* A B2 Bucket to store your backup files - Create a new one [here](https://secure.b2.com/b2_buckets.htm).
* An [Application Key](https://secure.b2.com/app_keys.htm) with write access to the previous created backup. This is required to authenticate in your B2 account to upload files.


## Usage

This docker image contains [b2](https://www.b2.com/b2/docs/quick_command_line.html) command line tool as well as postgres client with **pg_dump** tool.

To backup your Postgres Database you can run the following command:

```sh
docker run \
    -e PG_HOST=<posgres_host> \
    -e PG_USER=<postgres_user> \
    -e PG_PASSWORD=<postgres_password> \
    -e PG_DUMP_DBS="space separated list of databases to backup" \
    -e B2_APPLICATION_KEY_ID=<b2_application_key_id> \
    -e B2_APPLICATION_KEY=<b2_application_key> \
    -e B2_BUCKET=<b2_bucket_path> \
 b2-pg-backup
```

The following envrionment variables are available:

| Name                  	| Description                                                                                            	| Required 	|
|-----------------------	|--------------------------------------------------------------------------------------------------------	|----------	|
| PG_HOST               	| The hostname or IP Address of the Postgres instance to bucket. <br>Must be acessible by the container. 	| Yes      	|
| PG_USER               	| The Postgres user to authenticate                                                                      	| Yes      	|
| PG_PASSWORD           	| The Postgres user password                                                                             	| Yes      	|
| PG_PORT               	| Postgres Database Port. Defaults to 5432 if not set                                                    	| No       	|
| PG_DUMP_DBS           	| A space separated string with the list of database names to backup.                                    	| Yes      	|
| PG_DUMP_ARGS          	| Optional List of extra args to pass to the "pg_dump" command. Ex: ("--inserts --no-owner"              	| No       	|
| B2_BUCKET             	| The backbalze Bucket name. Can contain a subfolder. <br>Ex: my-bucket/subfolder                        	| Yes      	|
| B2_APPLICATION_KEY_ID 	| Backblaze Application Key ID credential                                                                	| Yes      	|
| B2_APPLICATION_KEY    	| Backblaze Application Key credential                                                                   	| Yes      	|


## FAQ

### How to run backups on a schedule?

- This tool doens´t assume how and when do you want to run your backups. If you want to run it on a schedule, you can run the regular tools for running scheduled tasks like Cron or Kubernetes Jobs.

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Developing

It is recommended to install `direnv` and `lefthook` to a better development process.

* [direnv](https://direnv.net/)
* [lefthook](https://github.com/evilmartians/lefthook)

```
make setup-env
```

This will install the Git Hooks and create an `.env` file from the `.env.example` template. You will need to add your backblaze keys there.

You can start a test Postgres container as well an application container using: `make dev`.

All the core logic is placed on `backup.sh` script at the root of this repository. This file is mounted as a volume on the docker container, so you can easily change it and see your changes.


## 💛 Support the project

If this project was useful to you in some form, I would be glad to have your support.  It will help to keep the project alive and to have more time to work on Open Source.

The sinplest form of support is to give a ⭐️ to this repo.

You can also contribute with [GitHub Sponsors](https://github.com/sponsors/brpaz).

[![GitHub Sponsors](https://img.shields.io/badge/GitHub%20Sponsors-Sponsor%20Me-red?style=for-the-badge)](https://github.com/sponsors/brpaz)

Or if you prefer a one time donation to the project, you can simple:

<a href="https://www.buymeacoffee.com/Z1Bu6asGV" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

## Author

👤 **Bruno Paz**

* Website: [brunopaz.dev](https://brunopaz.net)
* Github: [@brpaz](https://github.com/brpaz)

## 📝 License

Copyright © 2021 [Bruno Paz](https://github.com/brpaz).

This project is [MIT](https://opensource.org/licenses/MIT) licensed.
