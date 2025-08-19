# Claude Instructions for docker-makemkv

## Project Overview
This is an enhancement layer for the jlesage/docker-makemkv Docker container that adds automatic logging and multi-service notifications via Apprise. The project builds FROM the upstream image rather than recreating it.

## Key Architecture
- **Base Image**: `jlesage/docker-makemkv:latest` - Provides full MakeMKV functionality
- **Enhancement Layer**: Adds logging and notifications without modifying base functionality
- **Monitoring**: Watches MakeMKV's debug log file and parses events for lifecycle tracking
- **Notifications**: Uses Apprise library for 80+ notification service support

## Important Files
- `startapp.sh` - Enhanced launcher that configures MakeMKV settings and starts log watcher
- `log-watcher.sh` - Monitors for MakeMKV log file creation and tails new entries
- `makemkv-monitor.sh` - Parses log events and triggers notifications for start/complete/error
- `notify.py` - Apprise notification handler with clean formatting
- `Dockerfile` - Builds on jlesage/makemkv:latest, adds Python/Apprise

## Testing & Development

### Building Locally
```bash
docker build -t makemkv-test .
```

### Testing Notifications
1. Ensure `apprise.yml` exists in config directory with valid service URLs
2. Insert a disc and start a rip
3. Monitor with: `docker logs -f makemkv`

### Key Environment Variables
- `NOTIFY_START` - Enable/disable rip start notifications (default: 1)
- `CONTAINER_DEBUG` - Enable makemkvcon debug logging (default: 0)

## GitHub Container Registry
Published as `ghcr.io/st0nefish/docker-makemkv` via GitHub Actions. 
Builds are triggered automatically on push to master branch.

## Notification Flow
1. MakeMKV GUI writes to `/config/MakeMKV_log.txt` (debug mode auto-enabled)
2. `log-watcher.sh` uses `tail -n0 -f` to monitor new log entries
3. `makemkv-monitor.sh` parses events:
   - "Saving X titles into directory" = rip started
   - "Copy complete" = rip finished (check saved/failed counts)
4. `notify.py` formats and sends via Apprise

## Important Notes
- Movie titles are extracted from output paths (works best with MakeMKV's default naming)
- The container auto-configures MakeMKV settings for optimal notification support
- DestinationType must be "Semi-automatic" (2) for title extraction to work
- All scripts must be executable in the Docker image

## Common Issues
- **No notifications**: Check `/config/apprise.yml` exists and has valid URLs
- **"Unknown Title" in notifications**: MakeMKV DestinationType is set to "Flat" instead of "Semi-automatic"
- **False notifications on restart**: Fixed with `tail -n0` flag to ignore old log entries

## Upstream Documentation
For base MakeMKV functionality, see: https://github.com/jlesage/docker-makemkv