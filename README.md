# Infrastructure Lab

Personal lab for infrastructure automation, monitoring, and backup scripts — built while learning DevOps/Cloud skills (Bash, Python, Git, and later Terraform/AWS).

This repo supports the operation of my [IT Asset Manager](#) app and other homelab servers (VMware ESXi, Ubuntu VMs), but is kept separate from application source code.

## Structure

| Folder | Purpose |
|---|---|
| `backup/` | Scripts to back up databases/files automatically (cron-based) |
| `monitoring/` | Health check, uptime monitor, log parser scripts |
| `ssh-automation/` | Python scripts to run commands across multiple servers via SSH |
| `config/` | Config files (server lists, etc.) — real configs are gitignored, only `.example` files are committed |

## Setup

1. Clone the repo
```bash
   git clone https://github.com/chihuan2309-byte/Infrastructure-Lab.git
   cd Infrastructure-Lab
```
2. Create a Python virtual environment
```bash
   python3 -m venv venv
   source venv/bin/activate   # Linux/Mac
   venv\Scripts\activate      # Windows
   pip install -r requirements.txt
```
3. Copy example config and fill in real values
```bash
   cp config/servers.example.json config/servers.json
```
4. Set environment variables (Telegram bot token, etc.) in a local `.env` file (never committed)

## Scripts

_(Updated as scripts are added)_

- `backup/backup_db.sh` — backs up SQLite database, rotates backups older than 7 days
- `monitoring/health_check.sh` — checks CPU/RAM/disk usage, logs warnings
- `monitoring/uptime_monitor.py` — checks app uptime, alerts via Telegram
- `ssh-automation/check_disk_multi_server.py` — checks disk usage across multiple servers via SSH

## Status

🚧 Work in progress — learning project, updated as new automation/DevOps skills are added.

## License

MIT