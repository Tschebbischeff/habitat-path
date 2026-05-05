[![License: AGPL-3.0](https://img.shields.io/badge/License-AGPL--3.0-blue?style=flat)](./LICENSE)
![Development: Prototyping](https://img.shields.io/badge/Development-Prototyping-orange?style=flat)
![Version](https://img.shields.io/badge/dynamic/json?label=Version&color=yellow&style=flat&url=https%3A%2F%2Fraw.githubusercontent.com%2Ftschebbischeff%2Fhabitat-path%2Frefs%2Fheads%2Fmain%2Fmetadata.json&query=%24.version)

# Habitat: Path

**🚧
This project is currently under heavy development, any information may be subject to change.
🚧**

Habitat provides modular functionality for deployment on home lab devices. \
Each of the modules is designed as an opinionated docker stack that can be deployed on its own or together with other modules by sharing the same docker network.

## Available Modules

 - **[Path](https://github.com/Tschebbischeff/habitat-path)** \
 Network routing and reverse proxy
 - **[Scent](https://github.com/Tschebbischeff/habitat-scent)** \
 Identity provider, LDAP directory and access control
 - **[Chatter](https://github.com/Tschebbischeff/habitat-chatter)** \
 Message queue for realtime communication between modules
 - **[Sight](https://github.com/Tschebbischeff/habitat-sight)** \
 Real-time video streaming
 - **[Hoard](https://github.com/Tschebbischeff/habitat-hoard)** \
 Time-series database and persistent storage
 - **[Vigil](https://github.com/Tschebbischeff/habitat-vigil)** \
 Device monitoring, visualization and alerting
 - **[Vista](https://github.com/Tschebbischeff/habitat-vista)** \
 Central dashboards and device entry points

## Our Principles

![TODO](https://img.shields.io/badge/TODO-Coming_Soon_(TM)-red?style=flat)

## Module Features

[![Tailscale](https://img.shields.io/badge/Tailscale-_?style=flat&logo=tailscale&logoColor=242424&logoSize=auto&color=gray&labelColor=gray)](https://tailscale.com/)
[![Traefik](https://img.shields.io/badge/Traefik-_?style=flat&logo=traefikproxy&logoColor=24A1C1&logoSize=auto&color=gray&labelColor=gray)](https://traefik.io/traefik)

 - **Remote Access** \
 Tailscale provides remote access and serves as a first layer of security
 - **Automated SSL Certificates**\
 Generation for each subdomain via Porkbun API
 - **Internal Routing** \
 Merging dynamic configuration from other Habitat modules for routing subdomains to other services

### Planned
 - **Extended Configuration** \
 Connecting to custom Headscale control servers
 - **Domainless Operation** \
 Support for other domain providers and domainless operation

## Getting Started

### Requirements

 - Set up a Tailscale account (currently only tailscale.com is supported, support for custom control servers via headscale is planned)
   - Generate a one-time-use Auth Key for use as a secret later
 - Get a Porkbun domain (currently only Porkbun is supported as a PoC, domainless operation and other providers are planned).
   - Generate API credentials and store for use as secrets later
 - Clone the repository

### Configuration

The application is designed to be controlled exclusively with environment variables and secrets.

All secrets are expected to be files within a single folder. This folder can be set via environment variable (`SECRETS_DIR`) itself and defaults to `./.secrets` (git-ignored folder).

 - [List of environment variables](#environment-variables)
 - [List of secrets](#secrets)

#### Shell Exports

The existing [.env](./.env) file contains sane defaults for most necessary environment variables and is designed to let you overwrite any of those environment variables via exports from your shell before running the application.

*Example:*
```sh
export APP_HOST="my-habitat.example.com"
export APP_MODULES="path,scent,chatter,sight,hoard,vigil,vista"
export APP_SESSION_ID="$(cat /proc/sys/kernel/random/uuid)"
export APP_NAME_LABEL="MyHabitat"
export TIMEZONE="Europe/London"
export SECRETS_DIR="/run/secrets"
docker compose up
```

#### Repository ._env File

You can also create the file `._env` in the root directory of the cloned repository and instruct docker compose to use this file instead via the `--env-file` argument, i.e `docker compose up --env-file "./._env"` ([Compose documentation](https://docs.docker.com/compose/how-tos/environment-variables/variable-interpolation/)).

> ℹ️ The file `._env` is included in [.gitignore](./.gitignore) and is guaranteed to not interfere with future updates via `git pull`.

> *⚠️
> If this method is used you need to define **all** necessary environment variables from the [.env](./.env) file, as docker compose will not use that file as a fallback, it is therefore recommended to copy the current `.env` file and replace all variable values.
> ⚠️*

*Example:* [See .env](./.env)

#### Local .env File

It is also possible to create a `.env` file in an unrelated directory ([Compose documentation](https://docs.docker.com/compose/how-tos/environment-variables/variable-interpolation/#local-env-file-versus-project-directory-env-file)).

> ℹ️ In this case you need to set the additional variable `COMPOSE_FILE` to the path of the repository's compose file and all variables inside the [.env](./.env) file will be loaded as fallback, if your own `.env` file does not define them.

> ℹ️ You do not need to instruct docker compose to use this file as long as you run `docker compose up` from the directory containing your `.env` file.

*Example:*
```sh
# /path/to/your/.env
COMPOSE_FILE="/path/to/repository/compose.yml"
APP_HOST="my-habitat.example.com"
APP_MODULES="path,scent,chatter,sight,hoard,vigil,vista"
APP_SESSION_ID="$(cat /proc/sys/kernel/random/uuid)"
APP_NAME_LABEL="MyHabitat"
TIMEZONE="Europe/Madrid"
SECRETS_DIR="/run/secrets"
```

### Environment Variables

At build-time Docker requires the following environment variables to be populated:

| Name | Description | Example | Default |
| :-- | :-- | :-- | :-- |
| `APP_HOST` | The main URL the device will be reachable at. | `my-habitat.example.com` | *Empty* |
| `APP_MODULES` | A comma separated list of module names that are started in the same docker namespace (same project name) as this module. | `path,scent,chatter,sight,hoard,vigil,vista` | *Empty* |
| `APP_SESSION_ID` | A session ID used for synchronization of configuration between modules, should change every time all modules are restarted in unison and remain unchanged if a single module is restarted without being updated. | `$(cat /proc/sys/kernel/random/uuid)` | *Empty* |
| `APP_NAME_HOST` | The prefix for all docker networks and containers, that this application will create. Also used as the internal hostname within all containers. | `my-habitat` | `habitat` |
| `APP_NAME_LABEL` | The human readable name of the device. | `My Habitat` | `Habitat` |
| `TIMEZONE` | Timezone identifier passed on to containers. | `Europe/Paris` | `Europe/Berlin` |
| `VOLUME_DIR` | The directory in which [bind mounts](https://docs.docker.com/engine/storage/bind-mounts/) are placed *(Currently only named volumes are used)*. | `/path/to/my/volumes` | `./volumes` |
| `ENV_DIR` | The directory in which .env files for containers can be placed to override the default runtime config. | `/path/to/my/env` | `./env.d` |
| `SECRETS_DIR` | The directory in which files containing secrets for containers are placed. | `/run/secret` | `./secrets` |

### Secrets

The following secrets must exist within the `SECRETS_DIR` directory at build-time, otherwise running the stack will fail.
They are expected to be files with the secret value being the content of the file.

| (File) Name | Description | Documentation / How to Obtain |
| :-- | :-- | :-- |
| `TS_AUTHKEY` | Authentication key to use to register the device in Tailscale when starting for the first time.[^1] | [Tailscale Docs](https://tailscale.com/docs/features/access-control/auth-keys) |
| `PORKBUN_API_KEY` | API key to prove domain ownership over `APP_HOST` via DNS challenge to Porkbun. | [Porkbun Docs](https://kb.porkbun.com/article/190-getting-started-with-the-porkbun-api) |
| `PORKBUN_API_SECRET_KEY` | API secret key to prove domain ownership over `APP_HOST` via DNS challenge to Porkbun. | [Porkbun Docs](https://kb.porkbun.com/article/190-getting-started-with-the-porkbun-api) |

[^1]: It is advisable to use a one-time-use auth key and disable the key-expiry on the device once it has registered.

### Run the Application

 - Run `docker compose up` from the root directory of the repository or from the directory containing your `.env` file
 - Run `docker compose logs` and wait for the application to finish first-time setup and settle
 - Setup two DNS Records on Porkbun for the domain set up via `APP_HOST`
  - `A` record for `${APP_HOST}` pointing to the IP of your new device on Tailscale
  - `CNAME` record for `*.${APP_HOST}` pointing to `${APP_HOST}`

## Acknowledgments and Licensing

This project is licensed under the [GNU Affero General Public License v3.0 (AGPL-3.0)](./LICENSE).

Copyright (c) 2026, [Tschebbischeff](https://github.com/Tschebbischeff). \
All rights reserved to the extent permitted by the AGPLv3.

For third-party license details and attribution, please see [Third-Party Licenses](./THIRD-PARTY-LICENSES.md).