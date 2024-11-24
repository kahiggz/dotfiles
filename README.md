# Dotfiles Installation Guide

Welcome to the dotfiles repository! Follow these simple steps to set up your environment and enjoy a seamless development experience.

---

## 🚀 Installation

1. **Clone the Repository**
   - Navigate to your `$HOME` directory.
   - Use Git to clone the repository:
     ```bash
     git clone git@github.com/kahiggz/dotfiles.git
     cd dotfiles
     ```

2. **Symlink with GNU Stow**
   - Make sure you have `stow` installed:
     ```bash
     sudo apt install stow
     ```
   - Navigate to the `dotfiles` folder (if not already there):
     ```bash
     cd dotfiles
     ```
   - Use `stow` to create symlinks:
     ```bash
     stow .
     ```

---

## 📦 TMUX Setup

### Prerequisites

- **Install TMUX**
  Ensure TMUX is installed on your system:
  ```bash
  sudo apt install tmux
# Install TPM (TMUX Plugin Manager)

Follow the installation instructions from TPM’s [GitHub page](https://github.com/tmux-plugins/tpm).

## Setting Up TMUX

1. Launch TMUX and install the plugins:

   ```bash
   # Inside TMUX, press:
   Ctrl + A, then I
If you encounter any issues, source the TMUX configuration manually:
tmux source-file ~/.tmux.conf

🎉 You’re All Set!

Enjoy your customized development environment! If you run into any issues, feel free to open an issue in the repository or check the documentation.
