# MakeMKV Docker Container - Enhanced Edition

Enhancement layer for [jlesage/docker-makemkv](https://github.com/jlesage/docker-makemkv) that adds automatic logging and multi-service notifications.

## What This Adds

This builds on top of the excellent [jlesage/docker-makemkv](https://github.com/jlesage/docker-makemkv) base image, adding:

- ✅ **Full Docker Logging** - All MakeMKV output streams to `docker logs`
- ✅ **Multi-Service Notifications** via [Apprise](https://github.com/caronc/apprise) (80+ services):
  - Rip started with movie title and output path
  - Rip completed with duration and title count  
  - Rip failures with error details
- ✅ **Automatic Configuration** - Sets optimal MakeMKV settings for notifications

For core MakeMKV functionality and configuration, see the [upstream documentation](https://github.com/jlesage/docker-makemkv#readme).

## Quick Start

```yaml
# docker-compose.yml
services:
  makemkv:
    image: ghcr.io/st0nefish/docker-makemkv:latest
    container_name: makemkv
    ports:
      - "5800:5800"  # Web GUI
    volumes:
      - ./config:/config
      - /path/to/output:/output
      - /path/to/storage:/storage:ro
    devices:
      - /dev/sr0:/dev/sr0  # Your optical drive
    environment:
      - TZ=America/New_York
```

For notifications:
1. Copy `apprise.yml.example` to `./config/apprise.yml`
2. Add your service URLs per [Apprise docs](https://github.com/caronc/apprise/wiki)
3. Start container: `docker-compose up -d`

## Notifications

This container uses [Apprise](https://github.com/caronc/apprise) for notifications, supporting 80+ services including Discord, Slack, Telegram, Email, Pushover, and more.

To configure notifications:
1. Copy `apprise.yml.example` to your config directory as `apprise.yml`
2. Add your notification service URLs following the [Apprise documentation](https://github.com/caronc/apprise/wiki)
3. Notifications will automatically work on the next rip (no restart needed)

The `apprise.yml` file should be placed in your mounted config directory (e.g., `./config/apprise.yml`).

**Note:** Movie titles in notifications are extracted from the output path. This works best with MakeMKV's default naming scheme (`/output/<Movie Title>/`).

## Environment Variables (Enhanced)

| Variable | Description | Default |
|----------|-------------|---------|
| `NOTIFY_START` | Send notification when rip starts | 1 |
| `CONTAINER_DEBUG` | Enable makemkvcon debug logging | 0 |

See [upstream docs](https://github.com/jlesage/docker-makemkv#environment-variables) for all base image variables.

## Installation

```bash
docker pull ghcr.io/st0nefish/docker-makemkv:latest
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

- **Base Image**: [jlesage/docker-makemkv](https://github.com/jlesage/docker-makemkv)
- **Enhancement Layer**: [st0nefish](https://github.com/st0nefish)
- **Notifications**: [Apprise](https://github.com/caronc/apprise)