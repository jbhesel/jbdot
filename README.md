# jbdot


## Configuration of my ubuntu machine in different layers

 - keyboard  CapsLock, Cursorkeys
 - windowmanager i3
 - shell zsh
 - editor neovim
 - filemanager ranger
 - programming in coffeescript
 - markdown and preview
 - browser chromium with vimium

## Windowmanager

I use i3 as windowmanager. The configuration path is in ../.config/i3/config

    !cp ../.config/i3/config .
    
I made a programm that extracts the keybindings

    !coffee map_i3.coffee

The result is in i3_keybind.md
This table is also appended to the original config File.

## Keybindings in this file

Commands from my vim configuration, that I sometimes not remember, but are usefull in this file:

ls -l

 - <space>g  Execute cursorline in shell
