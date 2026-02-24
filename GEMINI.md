# Neovim Configuration with Nix

This directory contains a Neovim configuration managed by Nix and the `nix2nvimrc` flake. It provides a modular and reproducible way to set up the editor with different sets of plugins and language support.

## Project Overview

*   **Framework:** This is a Nix flake that leverages the `nix2nvimrc` library to configure Neovim.
*   **Structure:**
    *   `flake.nix`: The main entry point that defines dependencies, packages, and modules.
    *   `configs/`: Contains individual `.nix` files for configuring different plugins and aspects of Neovim.
    *   `modules/`: Contains Nix modules that provide the structure for the configuration.
    *   `lib.nix`: Contains helper functions for the Nix configuration.
*   **Key Technologies:**
    *   [Nix](https://nixos.org/): For package and configuration management.
    *   [Neovim](https://neovim.io/): The editor being configured.
    *   [Lua](https://www.lua.org/): For Neovim-specific configuration and plugins.
*   **Features:**
    *   **Modular Configuration:** Each plugin or configuration area (e.g., `lsp`, `treesitter`, `telescope`) is managed in its own file within the `configs/` directory.
    *   **Multiple Configurations:** The flake builds several variants of Neovim with different feature sets (e.g., `nvim-min`, `nvim-admin`, `nvim-dev`).
    *   **Reproducible Builds:** Nix ensures that the Neovim configuration is consistent and reproducible across different machines.

## Building and Running

The primary way to interact with this project is through the Nix CLI.

*   **Build the configuration:** The continuous integration (CI) uses `nix-fast-build` to test the build. To build all the defined Neovim configurations, you can run a similar command:
    ```bash
    nix build .#
    ```
    This will create `result` symlinks in the current directory for each of the builds.

*   **Run a specific configuration:** To run one of the Neovim configurations, you can use `nix run`:
    ```bash
    # Run the 'admin' configuration
    nix run .#nvim-admin

    # Run the 'dev' configuration
    nix run .#nvim-dev
    ```

## Development Conventions

*   **Configuration:** All Neovim plugins and settings are managed through `.nix` files in the `configs/` directory. To add or modify the configuration, you should edit the files in this directory.
*   **Enabling/Disabling Configurations:** The `modules/enable.nix` file defines a mechanism to enable or disable configurations. This allows for easy customization of the build.
*   **Formatting:** The project uses `nixfmt-tree` for formatting Nix files. You can format the entire project by running:
    ```bash
    nix fmt
    ```
*   **Keymaps:** Global key mappings are defined in `configs/global.nix`. Plugin-specific keymaps are typically defined within the plugin's own configuration file. The leader key is set to `<Space>` in `configs/leader.nix`.
