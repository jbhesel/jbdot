#!/usr/local/bin/coffee
""" show Keybindings of i3
Read the config of i3 and make a table of used key-bindings

#i3 keyboard table(36)
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
# TODO extract dependency of arrToMd
# This is a function, that makes an array of hash or a hash of hash to markdown
NL = '\n'

writeIfNew = (filename, content) ->
    if filename.toFile().exist
        old = filename.read()
        return if old is content
    console.log 'writing new ', filename
    filename.write content # write new content to file

readConfig = (i3_text) ->
    lastcomment = ''
    arr = _.compact _.map i3_text.split(NL), (row) ->
        [cmd, key, text1, text2] = row.split ' '
        # normally the command is uses as comment, but if we need another text
        # we can preceed the command with a line starting with #!
        """ in this example, 'new terminal" is the text
        #! new terminal
        bindsym $mod+Return exec i3-sensible-terminal
        """
        lastcomment = row if cmd is '#!'
        return unless cmd is 'bindsym'
        text = text1 + ' ' + (text2 or '')
        text = lastcomment[3..] if lastcomment.startsWith '#!'
        lastcomment = ''
        key = key.replace '$mod+', ''
        key: key
        text: text
    #qsx.pex console.log md arr, maxrow:9
readConfigMd = """
key           |text
---           |---
Return        |new terminal
Shift+q       |kill focused window
d             |dmenu launcher
j             |focus left
k             |focus down
i             |focus up
l             |focus right
Left          |focus left
Down          |focus down
Up            |focus up
Right         |focus right
Shift+j       |move left
Shift+k       |move down
...
"""

buildKeyboardTable = (bindingA) ->
    # The order of keys on the keyboard
    keysort =  "
      ^   0 1 2 3 4 5 6 7 8 9 0 = ? ' Back 
      Tab q w e r t z u i o p ü + Return
      Mod3 a s d f g h j k l odiaeresis ä # 
      Shift < y x c v b n m , . - Shift_R
      Fn Ctrl Win Alt Space AltGr Print Strg 
      Up Left Down Right Pageup PageDown
    "
    keyboard = {}
    keyboardA = keysort.split ' '
    _.each bindingA, (rec) ->
        if rec.key.startsWith 'Shift+'
            shift='Shift'
            key = rec.key.replace 'Shift+', ''
        else
            shift = 'Normal'
            key = rec.key
        k = keyboard[key] ?= {}
        k.key = key
        k.sort = keyboardA.indexOf key
        k[shift] = rec.text
    keyboard
    # qsx.pex md keyboardTable, title:'i3-keybind-table', maxrow:4
buildi3_keybind = """
#i3-keybind-table(36)
key|sort|Normal       |Shift
---|--- |---          |---
0  |3   |switch to ws0|move to ws0
1  |4   |switch to ws1|move to ws1
2  |5   |switch to ws2|move to ws2
3  |6   |switch to ws3|move to ws3
"""

makeKeyboardMd = (keyboardTable) ->

    # Keyboard bindings as Markdown Table, only selected coloums
    i3_keybind = md _.sortBy(keyboardTable, 'sort'),
        title: 'i3-keybind-table use with Win'
        collist:'key,Normal,Shift'
makeKeyboardMdMd = """
#i3-keybind-table(36)
key       |Normal            |Shift
---       |---               |---
space     |focus mode_toggle |floating toggle
0         |switch to ws0     |move to ws0
1         |switch to ws1     |move to ws1
2         |switch to ws2     |move to ws2
"""

makeComment = (i3_keybind) ->
    # add a comment to each line
    commentTableMd = _.map(i3_keybind.split(NL), (row) ->
        '# '+ row
    ).join(NL) + "\n#  made with jbdot/map_i3.coffee"
    commentTableMd
makeCommentMd = """
# #i3-keybind-table(36)
# key       |Normal            |Shift
# ---       |---               |---
# space     |focus mode_toggle |floating toggle
# 0         |switch to ws0     |move to ws0
# 1         |switch to ws1     |move to ws1
# 2         |switch to ws2     |move to ws2
"""

i3_path = '../.config/i3/config'
bindingA = readConfig i3_path.read()
i3_keybind = makeKeyboardMd buildKeyboardTable(bindingA)
console.log i3_keybind
commentTableMd = makeComment i3_keybind
#
# put the new table at the end of the configuration file.
# Don't define keybindings behind this table

new_i3 = i3_path.read().left('\n# #i3-') + NL + commentTableMd
# write table to config file if changes found
writeIfNew i3_path, new_i3
# write new keybinding table to documentation
writeIfNew 'i3_keybind.md', i3_keybind
