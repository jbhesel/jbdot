#!/usr/local/bin/coffee
""" install keybindings with xmodmap
! [xmodmap - ArchWiki](https://wiki.archlinux.org/index.php/Xmodmap)
"""
_ = require '/qsx/intra/2020/node/node_modules/underscore/underscore'
qsx = require '/qsx/intra/2020/node/qsx'
md = qsx.arrToMd
print = console.log
NL = '\n'

xmodmaptxt = """
! [xmodmap - ArchWiki](https://wiki.archlinux.org/index.php/Xmodmap)
! xmodmap myxmodmap  # sets this keymap
! setxkmap           # return to normal
! xmodmap -pke       # show keymap
! setxkbmap; xmodmap ~/jbdot/myxmodmap # restart
! see xmodmap.coffee

! remove Caps Lock
clear lock
remove Lock = Caps_Lock
remove Shift = Caps_Lock
! add Mode_switch   AltGr to CapsKey
keycode 66 = NoSymbol NoSymbol
keycode 66 = Mode_switch

"""

# QWERTY (Latin) version
# http://en.wikipedia.org/wiki/QWERTY
# https://tldp.org/HOWTO/Intkeyb/x336.html
# copy from /usr/share/X11/xkb/symbols/ph
qwertz= """
 ┌───┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┲━━━━━━━┓
 │ ° │ !   │ "   │ §   │ $   │ %   │ &   │ /   │ (   │ )   │ =   │ ?   │ `   ┃ ⌫ Bak ┃
 │ ^ │ 1   │ 2   │ 3   │ 4   │ 5   │ 6   │ 7   │ 8   │ 9   │ 0   │ ß b │ á   ┃ Space ┃
 ┢━━━┷━┱───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┴─┬───┺━┯━━━━━┩
 ┃     ┃ Q   │ W   │ E   │ R   │ T   │ Z   │ U 7 │ I 8 │ O 9 │ P   │ Ü   │ *   │     │
 ┃Ta↹  ┃ q   │ w " │ e [ │ r ] │ t ~ │ z / │ u ⌫ │ i ↑ │ o Î │ p = │ ü   │ + ~ │     │
 ┣━━━━━┻┱────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┬────┴┲━━━━┷┬━━━━┪
 ┃      ┃ A   │ S   │ D   │ F   │ G   │ H   │ J 4 │ K 5 │ L 6 │ Ö   │ Ä   ┃ '   │    ┃
 ┃Ca ⇬  ┃ a b │ s / │ d { │ f } │ g | │ h E │ j ← │ k ↓ │ l → │ ö : │ ä   ┃ #   │  ⏎ ┃
 ┣━━━━━┳┹────┬┴────┬┴────┬┴────┬┴────┬┴────┬┴────┬┴────┬┴────┬┴────┬┴────┲┻━━━━━┴━━━━┫
 ┃     ┃   ¦ │ Y   │ X   │ C   │ V   │ B   │ N 0 │ M 1 │ ; 2 │ : 3 │ _   ┃           ┃
 ┃Sht ⇧┃     │ y   │ x   │ c ( │ v ) │ b < │ n > │ m ⏎ │ , D │ . ? │ -   ┃Shift ⇧    ┃
 ┣━━━━━╋━━━━━╋━━━━━╋━━━━┱┴─────┴─────┴─────┴─────┴────┲┷━━━━━╈━━━━━┷━┳━━━┻━━━┳━━━━━━━┫
 ┃     ┃     ┃     ┃    ┃              '    0         ┃      ┃       ┃       ┃       ┃
 ┃Fn   ┃Ctrl ┃  Win┃Alt ┃            Space  "         ┃AltGr⇮┃Print  ┃Ctrl   ┃       ┃
 ┗━━━━━┻━━━━━┻━━━━━┻━━━━┹─────────────────────────────┺━━━━━━┻━━━━━━━┻━━━━━━━┻━━━━━━━┛
"""
# a = 
table = qsx.markdown.readTable """
low| up | mod3      |shift     | kom
---|----|-----------|----      | ---
w  | W  | "         | 1        | 2
e  | E  | [         | --       | --
r  | R  | ]         | --       | --
t  | T  | ~         | --       | --
z  | Z  | /         | --       | --
u  | U  | BackSpace | --       | 7
i  | I  | Up        | Next     | 8
o  | O  | Insert    | Delete   | 9
p  | P  | equal     | --       | --
h  | H  | Escape    | --       | .
j  | J  | Left      | Home     | 4
k  | K  | Down      | Prior    | 5
l  | L  | Right     | End      | 6
ö  | Ö  | colon     | --       | :
a  | A  | backslash | --       | --
s  | S  | /         | --       | --
d  | D  | {         | --       | --
f  | F  | }         | --       | --
g  | G  | bar       | --       | --
c  | C  | (         | --       | --
v  | V  | )         | --       | --
b  | B  | <         | --       | --
n  | N  | >         | --       | 0
m  | M  | Return    | --       | 1
,  | ;  | Delete    | --       | 2
.  | :  | .         | --       | 3
space|' | "         | --       | 0
"""
#

# map short symbols to long names
hash = qsx.markdown.readTable """
key | long
--- | ----
 /  | slash
 (  | parenleft
 )  | parenright
 ö  | odiaeresis
 Ö  | Odiaeresis
 "  | quotedbl
 '  | apostrophe
 ,  | comma
 .  | period
 -- | NoSymbol
 ;  | semicolon
 :  | colon
 .  | period
 [  | bracketleft
 ]  | bracketright
 {  | braceleft
 }  | braceright
 ▽  | Next
 △  | Prior
 ~  | asciitilde
 <  | less
 >  | greater
"""

arr = _.map table, (rec) ->
    # print hash
    line = "keysym _low_ = _low_ _up_ _mod3_ _shift_ _kom_ ".multiReplaceReg rec
    _.each hash, (rec) ->
        line = line.replace rec.key, rec.long
        line = line.replace rec.key, rec.long
    line

ex = (cmd) ->
    qsx.xexec cmd, (stdin) -> print stdin

xmodmaptxt += arr.join NL
print xmodmaptxt 
filename ='/home/jb/jbdot/myxmodmap'
filename.write xmodmaptxt
ex "setxkbmap ; xmodmap #{filename}"
ex 'xmodmap -e "keycode any = Tab"'
ex 'xmodmap -e "keycode 23 = ISO_Level3_Shift"'
ex 'xcape -e "ISO_Level3_Shift=Tab" '

