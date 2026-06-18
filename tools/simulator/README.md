# SKAPP Device Simulator

Stand-in for a real ESP32-C6 device during APP development (Phase 1 and Phase 3). Speaks the NDJSON wire format from [shared/cli_contract.md](../../shared/cli_contract.md) over a plain TCP socket.

This is **not** a BLE simulator. The APP must be built in "dev mode" to connect over TCP instead of BLE; production builds only use BLE.

## Requirements

Python 3.10 or newer. No third-party packages.

## Run

```
python simulator.py
```

Defaults: thermostat on `127.0.0.1:17653` with serial `THR-xxxxxx`.

Options:

```
python simulator.py --prefix LGT --serial LGT-AB12CD
python simulator.py --port 17654
python simulator.py --prefix FAN --model fan-v2 --fw-version 1.2.3
```

## Quick manual test

Without the APP, you can poke the simulator with `nc` or Python to verify the contract:

```
python -c "import socket,json; s=socket.create_connection(('127.0.0.1',17653)); s.sendall(b'{\"id\":1,\"cmd\":\"device_info\"}\n'); print(s.recv(4096).decode())"
```

Expected: a one-line JSON response with the device identity.

## Scope

The simulator implements the mandatory command set only. Device-specific commands (e.g., `temp_set` for thermostats) will be added per-device during Phase 3.

Single client at a time; kill with Ctrl+C.
