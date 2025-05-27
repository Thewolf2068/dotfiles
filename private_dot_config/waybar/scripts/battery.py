
#!/usr/bin/env python3
"""
Waybar module script to display headphone battery level using headsetcontrol.

This script runs `headsetcontrol -o JSON` at regular intervals, parses the `devices[0].battery.level` field,
and outputs a JSON object suitable for Waybar each time. If `level` is -1 or no device is found, the module will be empty.
"""
import subprocess
import json
import sys
import time
import argparse

DEFAULT_INTERVAL =  2 # seconds




def get_battery_level():
    """
    Runs 'headsetcontrol -o JSON' and returns the battery level of the first device.
    Returns:
        int: Battery level (0-100), or -1 if empty/error/no device.
    """
    try:
        result = subprocess.run(
                ["headsetcontrol", "-o", "JSON"],
                capture_output=True,
                check=True,
                text=True
                )
        data = json.loads(result.stdout)
        devices = data.get("devices", [])
        if not devices:
            return -1
        battery = devices[0].get("battery", {})
        level = battery.get("level", -1)
        return level if isinstance(level, int) else -1
    except (subprocess.CalledProcessError, json.JSONDecodeError, FileNotFoundError):
        return -1


def format_output(level):
    """
    Formats the output for Waybar.

    Args:
        level (int): Battery level.

    Returns:
        dict: JSON-serializable dictionary with fields:
            - text: Display text (empty if level is -1).
            - class: Custom CSS class for styling.
            - alt: Alt text for module.
    """
    if level == -1:
        text = ""
    else:
        text = f"   {level}%"

    return {
            "text": text,
            "class": "custom-headset-battery",
            "alt": "headset"
            }


def main(interval):
    try:
        while True:
            level = get_battery_level()
            output = format_output(level)
            sys.stdout.write(json.dumps(output) + "\n")
            sys.stdout.flush()
            time.sleep(interval)
    except KeyboardInterrupt:
        # Exit cleanly on Ctrl+C
        sys.exit(0)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Waybar headset battery module")
    parser.add_argument(
            "-i", "--interval",
            type=int,
            default=DEFAULT_INTERVAL,
            help=f"Refresh interval in seconds (default {DEFAULT_INTERVAL})"
            )
    args = parser.parse_args()
    main(args.interval)
    main(args.interval)
