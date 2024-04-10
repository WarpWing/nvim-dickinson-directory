# nvim-dickinson-directory
A Neovim Plugin that utilizes the Dickinson College Campus Directory for easy search.

![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)

# Install

So I'm technically cheating by providing a Lua wrapper for my Python CLI. It'll be real lua... eventually. For now, this works ad hoc. First, you should clone the repository:

```bash
git clone https://github.com/WarpWing/nvim-dickinson-directory.git
```
Then you should install the requirements.
```bash
pip3 install -r dickinson_directory/requirements.txt
```
Proceed to install the plugin in your Neovim plugins directory and update your neovim config (usually init.vim). You should be able to just set your runtime path such as:
```vim
set runtimepath+=~/path/to/dickinson_directory
```

# Usage
The plugin provides the following commands to search the Dickinson College directory:
 - :DickDirName "First Last" - Search by name (replace "First Last" with the actual name)
 - :DickDirEmail "email@dickinson.edu" - Search by email (replace "email@dickinson.edu" with the actual email)
 - :DickDirDept "Department Name" - Search by department (replace "Department Name" with the actual department name)

# LICENSE
This is protected under the MIT License. Please refer to the license in the repository root

# Contributing
Please make any pull requests or issues to suggest or implement changes. This is still in testing so expect breaking changes. You can also email me at chermsit@dickinson.edu or on Discord: WarpWing#3866 for discussion.

