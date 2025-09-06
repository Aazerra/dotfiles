# 🏠 Dotfiles

My personal configuration files for Linux/Unix systems.  
Managed with a [bare git repo](https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git) so that my `$HOME` directory stays in sync across machines.

---

## 📦 What’s Inside
- Shell configuration (`.zshrc`, `.bashrc`, etc.)
- Git configuration (`.gitconfig`, `.gitignore`)
- Editor/IDE settings
- Terminal + prompt setup
- Scripts and aliases
- Other system tweaks

> ⚡️ I’ll keep adding features and documenting them here as the setup evolves.

---

## 🚀 Installation

Clone the repo as a **bare repository**:

```bash
git clone --bare git@github.com:yourusername/dotfiles.git $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
```

Ignore untracked files to keep `git status` clean:

```bash
dotfiles config --local status.showUntrackedFiles no
```

---

## 🔧 Usage

Some useful commands with the `dotfiles` alias:

```bash
dotfiles status     # check changes
dotfiles add .zshrc # track a new dotfile
dotfiles commit -m "update zshrc"
dotfiles push       # sync with remote
```

---

## 🌱 Features (WIP)

- [ ] Neovim config as submodule
