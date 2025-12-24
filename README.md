# Project: WIP

> **Status:** Pre-Alpha / Prototype
> **Author:** EternalsLegacy

This project is currently in the early planning and development stages. It is a solo project aiming to recreate classic survival horror mechanics on the Roblox platform.

The development workflow leverages external industry-standard tools for version control and code editing, synchronized into Roblox Studio.

---

## Tech Stack

### Programming Languages
* **Luau:** The primary scripting language (a derived version of Lua 5.1 with gradual typing and performance optimizations).

### Development Tools
* **Roblox Studio:** Game engine and environment rendering.
* **VS Code:** External code editor for scripting.
* **Rojo:** Synchronization tool to map the external file system to the Roblox DataModel.
* **Git / GitHub:** Version control and repository hosting.

---

## Project Structure & Architecture

This project utilizes a modular **Service/Controller** architecture.
* **Services (Server):** Handle game logic, data validation, and replication.
* **Controllers (Client):** Handle user input, visual rendering, and local physics.

### File System Mapping
This table outlines how local VS Code directories map to Roblox Studio Services via Rojo.

| VS Code Directory | Roblox Studio Service |
| :--- | :--- |
| `src/client` | **StarterPlayerScripts** |
| `src/server` | **ServerScriptService**  |
| `src/shared` | **ReplicatedStorage**    |

---

### Detailed Directory Overview

Below is the file tree of the `src` repository with descriptions of each module's responsibility.

```text
src
src
├── 🔵 client  (StarterPlayerScripts)
│   ├── ClientLoader.client.lua      # Client Bootstrapper: Initializes all Controllers.
│   ├── Controllers                  # Singleton modules for client-side systems.
│   │   ├── CameraController.client.lua      # Manages Fixed Camera Zone triggers.
│   │   ├── CharacterController.client.lua   # Handles movement speed & Head-Tracking (LookAt Mouse).
│   │   ├── InteractionController.client.lua # Manages custom ProximityPrompt visuals (SH2 Style).
│   │   └── UIController.client.lua          # Manages Menu states (Inventory, Maps).
│   │
│   └── UI                           # View Classes (Code-First UI Generation).
│       ├── InventoryMenu.lua        # RE2 Remake style Grid Inventory.
│       ├── InteractionIcon.lua      # Floating 2D Interaction Prompt.
│       ├── MapMenu.lua              # (WIP) Map Interface.
│       └── NotesMenu.lua            # (WIP) Document Reader.
│
├── 🟢 server  (ServerScriptService)
│   ├── Core
│   │   └── GameLoader.server.lua    # Server Bootstrapper.
│   └── Components                   # OOP Classes for interactive objects.
│       └── Door.lua                 # Logic for Locked/Key/Tweening Doors.
│
└── 🟡 shared  (ReplicatedStorage)
    ├── Assets                       # (Ignored by Rojo) Sounds, VFX, Models.
    ├── Network                      # (Ignored by Rojo) RemoteEvents.
    ├── Common                       # Utility modules.
    │   └── Utils
    │       └── UIBuilder.lua        # Factory module for creating UI instances via code.
    └── Systems
        └── CameraManager.lua        # OOP Class for camera manipulation.
