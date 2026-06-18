#!/usr/bin/env python3
"""
SmartKraft device simulator.

Stands in for a real ESP32-C6 device during Phase 1 / Phase 3 APP development.
Speaks the NDJSON wire format defined in shared/cli_contract.md over a plain
TCP socket. Not a real BLE stack — the APP must compile in "dev mode" to
connect via TCP instead of BLE.

Usage:
    python simulator.py                 # THR-K7M9P2 thermostat on :17653
    python simulator.py --prefix LGT --serial LGT-AB12CD
    python simulator.py --port 17654

The simulator implements the mandatory command set from the contract. It is
intentionally tiny and single-client — no threading, no async, no state
persistence. Kill with Ctrl+C.
"""

from __future__ import annotations

import argparse
import json
import random
import socket
import string
import sys
import time
from typing import Any

PROTOCOL_VERSION = "0.1.0"


def gen_serial(prefix: str) -> str:
    body = "".join(random.choices(string.ascii_uppercase + string.digits, k=6))
    return f"{prefix}-{body}"


class Device:
    """In-memory device state. Reset on each simulator restart."""

    def __init__(self, prefix: str, serial: str, model: str, fw_version: str):
        self.prefix = prefix
        self.serial = serial
        self.model = model
        self.fw_version = fw_version
        self.boot_time = time.time()
        self.wifi = {"connected": False, "ssid": None, "rssi": None, "ip": None}
        self.last_error: str | None = None
        self.time_valid = False
        self.time_unix: int | None = None

    @property
    def uptime_sec(self) -> int:
        return int(time.time() - self.boot_time)


def handle_request(dev: Device, req: dict[str, Any]) -> dict[str, Any]:
    """Process one request dict, return a response dict."""
    cmd = req.get("cmd")
    req_id = req.get("id", 0)
    args = req.get("args", {}) or {}

    def ok(result: Any) -> dict[str, Any]:
        return {"id": req_id, "ok": True, "result": result}

    def err(code: str, msg: str = "") -> dict[str, Any]:
        return {"id": req_id, "ok": False, "err": code, "msg": msg}

    if cmd == "device_info":
        return ok({
            "model": dev.model,
            "prefix": dev.prefix,
            "serial": dev.serial,
            "fw_version": dev.fw_version,
            "hw_version": "rev_A",
            "protocol_version": PROTOCOL_VERSION,
        })

    if cmd == "list_commands":
        return ok([
            "device_info", "list_commands", "version", "status",
            "factory_reset", "reboot",
            "wifi_scan", "wifi_set", "wifi_get", "wifi_clear",
            "logs_get", "ota_check", "ota_start", "time_set",
        ])

    if cmd == "version":
        return ok({"fw": dev.fw_version, "protocol": PROTOCOL_VERSION})

    if cmd == "status":
        return ok({
            "uptime_sec": dev.uptime_sec,
            "wifi": dev.wifi,
            "ble": {"paired_clients": 1},
            "last_error": dev.last_error,
            "time_valid": dev.time_valid,
            "time_unix": dev.time_unix,
        })

    if cmd == "factory_reset":
        if not args.get("confirm"):
            return err("INVALID_PARAM", "confirm flag required")
        dev.wifi = {"connected": False, "ssid": None, "rssi": None, "ip": None}
        dev.boot_time = time.time()
        return ok({"reset": True})

    if cmd == "reboot":
        dev.boot_time = time.time()
        return ok({"reboot": True})

    if cmd == "wifi_scan":
        return ok([
            {"ssid": "home", "rssi": -45, "auth": "wpa2"},
            {"ssid": "office", "rssi": -71, "auth": "wpa3"},
            {"ssid": "guest", "rssi": -82, "auth": "open"},
        ])

    if cmd == "wifi_set":
        ssid = args.get("ssid")
        if not ssid:
            return err("INVALID_PARAM", "ssid required")
        dev.wifi = {"connected": True, "ssid": ssid, "rssi": -55, "ip": "192.168.1.34"}
        return ok({"connected": True, "ip": "192.168.1.34"})

    if cmd == "wifi_get":
        return ok(dev.wifi)

    if cmd == "wifi_clear":
        dev.wifi = {"connected": False, "ssid": None, "rssi": None, "ip": None}
        return ok({"cleared": True})

    if cmd == "logs_get":
        return ok([
            {"ts": None, "lvl": "info", "tag": "boot", "msg": "simulator start"},
            {"ts": None, "lvl": "warn", "tag": "wifi", "msg": "no ap configured"},
        ])

    if cmd == "ota_check":
        return ok({"current": dev.fw_version, "latest": dev.fw_version, "url": None})

    if cmd == "ota_start":
        return err("NOT_READY", "simulator does not implement OTA")

    if cmd == "time_set":
        unix = args.get("unix")
        if not isinstance(unix, int):
            return err("INVALID_PARAM", "unix (int) required")
        dev.time_unix = unix
        dev.time_valid = True
        return ok({"time_valid": True})

    return err("UNKNOWN_CMD", f"no such command: {cmd}")


def serve(host: str, port: int, dev: Device) -> None:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as srv:
        srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        srv.bind((host, port))
        srv.listen(1)
        print(f"[{dev.serial}] listening on {host}:{port}  (protocol {PROTOCOL_VERSION})",
              flush=True)
        while True:
            conn, addr = srv.accept()
            print(f"[{dev.serial}] client connected: {addr}", flush=True)
            try:
                with conn:
                    handle_client(conn, dev)
            except ConnectionError as e:
                print(f"[{dev.serial}] connection error: {e}", flush=True)
            print(f"[{dev.serial}] client disconnected", flush=True)


def handle_client(conn: socket.socket, dev: Device) -> None:
    buf = b""
    while True:
        chunk = conn.recv(4096)
        if not chunk:
            return
        buf += chunk
        while b"\n" in buf:
            line, buf = buf.split(b"\n", 1)
            line = line.strip()
            if not line:
                continue
            try:
                req = json.loads(line.decode("utf-8"))
            except json.JSONDecodeError as e:
                resp = {"id": 0, "ok": False, "err": "INVALID_PARAM",
                        "msg": f"not json: {e}"}
            else:
                resp = handle_request(dev, req)
            conn.sendall((json.dumps(resp) + "\n").encode("utf-8"))


def main() -> int:
    parser = argparse.ArgumentParser(description="SmartKraft device simulator")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=17653)
    parser.add_argument("--prefix", default="THR",
                        help="3-letter device type prefix")
    parser.add_argument("--serial", default=None,
                        help="full serial; generated from prefix if omitted")
    parser.add_argument("--model", default="thermostat-v1")
    parser.add_argument("--fw-version", default="1.0.0")
    args = parser.parse_args()

    if len(args.prefix) != 3 or not args.prefix.isalpha():
        print("prefix must be exactly 3 alphabetic characters", file=sys.stderr)
        return 2

    serial = args.serial or gen_serial(args.prefix.upper())
    dev = Device(
        prefix=args.prefix.upper(),
        serial=serial,
        model=args.model,
        fw_version=args.fw_version,
    )

    try:
        serve(args.host, args.port, dev)
    except KeyboardInterrupt:
        print("\nshutting down", flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
