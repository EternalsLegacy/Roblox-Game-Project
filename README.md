# Project: WIP

> **Status:** Pre-Alpha / Prototype
> **Author:** EternalsLegacy

This project is currently in the early planning and development stages. It is a solo project aiming to recreate classic survival horror mechanics (Fixed Camera Angles, Tank Controls) on the Roblox platform.

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
├── 🔵 client  (StarterPlayerScripts)
│   ├── ClientLoader.client.lua      # Client Bootstrapper: Initializes all Controllers.
│   └── Controllers                  # Singleton modules for client-side systems.
│       ├── CameraController.client.lua  # Manages Zone-Detection & Camera logic.
│       ├── AudioController.client.lua   # (Planned) Handles music, SFX, and ambience.
│       ├── InputController.client.lua   # (Planned) Handles Tank-Controls & User Input.
│       └── UIController.client.lua      # (Planned) Manages GUI elements (Inventory, HUD).
│
├── 🟢 server  (ServerScriptService)
│   ├── Core
│   │   └── GameLoader.server.lua    # Server Bootstrapper: Initializes Services.
│   ├── Services                     # Core game mechanics (Server Singleton Pattern).
│   │   ├── CombatService.lua        # Damage calculation and enemy interaction.
│   │   ├── InventoryService.lua     # Backend inventory management.
│   │   └── PlayerDataService.lua    # Datastore saving/loading.
│   └── Components                   # OOP Classes for physical map objects (Doors, Pickups).
│
└── 🟡 shared  (ReplicatedStorage)
    ├── Assets                       # Populated in Studio: Sounds, VFX, UI models.
    ├── Common                       # Utility modules & definitions.
    │   ├── Data                     # Static Data (Loot tables, Item stats).
    │   ├── Types                    # Luau Type definitions (export type ...).
    │   └── Utils                    # Math & Helper functions.
    ├── Network                      # RemoteEvents / RemoteFunctions definitions.
    └── Systems                      # Standalone Logic Modules.
        └── CameraManager.lua        # OOP Class for camera manipulation (Tweening/Cuts).