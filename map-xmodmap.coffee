#!/usr/local/bin/coffee
""" show Keybindings of xmodmap
Read the config of neovim and make a table of used key-bindings

#neovim-keyboard-table
key                 |Normal            |Shift
---                 |---               |---
XF86AudioRaiseVolume|volume+           |-
XF86AudioLowerVolume|volume-           |-
XF86AudioMute       |toggle speaker    |-
XF86AudioMicMute    |toggle microphone |-
space               |focus mode_toggle |floating toggle
0                   |switch to ws0     |move to ws0
....

The table is sorted by the order on the keyboard.

This table is appended to the i3-config file as a comment
"""
_ = require '/qsx/intra/2020/node/node_modules/underscore/underscore'
qsx = require '/qsx/intra/2020/node/qsx'
md = qsx.arrToMd
NL = '\n'
print = console.log

writeIfNew = (filename, content) ->
    if filename.toFile().exist
        old = filename.read()
        return false if old is content
    filename.write content # write new content to file
    true

shortlong = qsx.markdown.readTable """
long               |short
----               |-----
XF86               |X.
Brightness         |Bright
Volume             |Vol
dead_              |-
quotemark          |Q
Hiragana_Katakana  |HK
ISO_Level3_Shift   |ISO3Shift
TouchpadToggle     |TouchToggle
ISO_Level3_Shift   |ISO3Shift
NoSymbol           |--
"""

qsx.xexec 'xmodmap -pke', (stdin) ->
    words = []
    arr = _.map stdin.split(NL), (line) ->
        rec =
            keynr: line.fromTo(' ','=').trim() 
        _.extend rec, qsx.hmap line.right('= ').split(' '), (val, i) ->
            word = val
            _.each shortlong, (r) ->
                word = word.replace r.long, r.short
            words.push word  if word.length > 10
            key: 'c'+i
            val: word
        rec
    xmodmappke = md _.sortBy(arr,'c0'), collist:'all'
    xmodmappke = """
        # xmodmap -pke before changes

        generated with map-xmodmap.coffee
        """ + xmodmappke
    print xmodmappke
    # print _.uniq words
    writeIfNew 'xmodmap-pke.md', xmodmappke # write new keybinding table to documentation

