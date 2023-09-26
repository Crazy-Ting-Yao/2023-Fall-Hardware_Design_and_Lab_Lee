# File saved with Nlview 7.0r6  2020-01-29 bk=1.5227 VDI=41 GEI=36 GUI=JA:10.0 non-TLS-threadsafe
# 
# non-default properties - (restore without -noprops)
property attrcolor #000000
property attrfontsize 8
property autobundle 1
property backgroundcolor #ffffff
property boxcolor0 #000000
property boxcolor1 #000000
property boxcolor2 #000000
property boxinstcolor #000000
property boxpincolor #000000
property buscolor #008000
property closeenough 5
property createnetattrdsp 2048
property decorate 1
property elidetext 40
property fillcolor1 #ffffcc
property fillcolor2 #dfebf8
property fillcolor3 #f0f0f0
property gatecellname 2
property instattrmax 30
property instdrag 15
property instorder 1
property marksize 12
property maxfontsize 15
property maxzoom 6.25
property netcolor #19b400
property objecthighlight0 #ff00ff
property objecthighlight1 #ffff00
property objecthighlight2 #00ff00
property objecthighlight3 #ff6666
property objecthighlight4 #0000ff
property objecthighlight5 #ffc800
property objecthighlight7 #00ffff
property objecthighlight8 #ff00ff
property objecthighlight9 #ccccff
property objecthighlight10 #0ead00
property objecthighlight11 #cefc00
property objecthighlight12 #9e2dbe
property objecthighlight13 #ba6a29
property objecthighlight14 #fc0188
property objecthighlight15 #02f990
property objecthighlight16 #f1b0fb
property objecthighlight17 #fec004
property objecthighlight18 #149bff
property objecthighlight19 #eb591b
property overlapcolor #19b400
property pbuscolor #000000
property pbusnamecolor #000000
property pinattrmax 20
property pinorder 2
property pinpermute 0
property portcolor #000000
property portnamecolor #000000
property ripindexfontsize 8
property rippercolor #000000
property rubberbandcolor #000000
property rubberbandfontsize 15
property selectattr 0
property selectionappearance 2
property selectioncolor #0000ff
property sheetheight 44
property sheetwidth 68
property showmarks 1
property shownetname 0
property showpagenumbers 1
property showripindex 4
property timelimit 1
#
module new Crossbar_2x2_4bit work:Crossbar_2x2_4bit:NOFILE -nosplit
load symbol Dmux_1x2_4bit work:Dmux_1x2_4bit:NOFILE HIERBOX pin sel input.left pinBus a output.right [3:0] pinBus b output.right [3:0] pinBus in input.left [3:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol Dmux_1x2_4bit work:abstract:NOFILE HIERBOX pin sel input.left pinBus a output.right [3:0] pinBus b output.right [3:0] pinBus in input.left [3:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol Mux_2x1_4bit work:Mux_2x1_4bit:NOFILE HIERBOX pin sel input.left pinBus a input.left [3:0] pinBus b input.left [3:0] pinBus f output.right [3:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol Mux_2x1_4bit work:abstract:NOFILE HIERBOX pin sel input.left pinBus a input.left [3:0] pinBus b input.left [3:0] pinBus f output.right [3:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol RTL_INV work INV pin I0 input pin O output fillcolor 1
load port control input -pg 1 -lvl 0 -x 0 -y 120
load portBus in1 input [3:0] -attr @name in1[3:0] -pg 1 -lvl 0 -x 0 -y 60
load portBus in2 input [3:0] -attr @name in2[3:0] -pg 1 -lvl 0 -x 0 -y 180
load portBus out1 output [3:0] -attr @name out1[3:0] -pg 1 -lvl 4 -x 630 -y 80
load portBus out2 output [3:0] -attr @name out2[3:0] -pg 1 -lvl 4 -x 630 -y 210
load inst d1 Dmux_1x2_4bit work:Dmux_1x2_4bit:NOFILE -autohide -attr @cell(#000000) Dmux_1x2_4bit -pinBusAttr a @name a[3:0] -pinBusAttr b @name b[3:0] -pinBusAttr in @name in[3:0] -pg 1 -lvl 2 -x 250 -y 50
load inst d2 Dmux_1x2_4bit work:abstract:NOFILE -autohide -attr @cell(#000000) Dmux_1x2_4bit -pinBusAttr a @name a[3:0] -pinBusAttr b @name b[3:0] -pinBusAttr in @name in[3:0] -pg 1 -lvl 2 -x 250 -y 170
load inst m1 Mux_2x1_4bit work:Mux_2x1_4bit:NOFILE -autohide -attr @cell(#000000) Mux_2x1_4bit -pinBusAttr a @name a[3:0] -pinBusAttr b @name b[3:0] -pinBusAttr f @name f[3:0] -pg 1 -lvl 3 -x 510 -y 50
load inst m2 Mux_2x1_4bit work:abstract:NOFILE -autohide -attr @cell(#000000) Mux_2x1_4bit -pinBusAttr a @name a[3:0] -pinBusAttr b @name b[3:0] -pinBusAttr f @name f[3:0] -pg 1 -lvl 3 -x 510 -y 180
load inst notcontrol_i RTL_INV work -attr @cell(#000000) RTL_INV -pg 1 -lvl 1 -x 70 -y 220
load net control -port control -pin d1 sel -pin m1 sel -pin notcontrol_i I0
netloc control 1 0 3 20 120 180 120 440
load net in1[0] -attr @rip(#000000) in1[0] -pin d1 in[0] -port in1[0]
load net in1[1] -attr @rip(#000000) in1[1] -pin d1 in[1] -port in1[1]
load net in1[2] -attr @rip(#000000) in1[2] -pin d1 in[2] -port in1[2]
load net in1[3] -attr @rip(#000000) in1[3] -pin d1 in[3] -port in1[3]
load net in2[0] -attr @rip(#000000) in2[0] -pin d2 in[0] -port in2[0]
load net in2[1] -attr @rip(#000000) in2[1] -pin d2 in[1] -port in2[1]
load net in2[2] -attr @rip(#000000) in2[2] -pin d2 in[2] -port in2[2]
load net in2[3] -attr @rip(#000000) in2[3] -pin d2 in[3] -port in2[3]
load net ncontrol -pin d2 sel -pin m2 sel -pin notcontrol_i O
netloc ncontrol 1 1 2 180 240 420
load net out1[0] -attr @rip(#000000) f[0] -pin m1 f[0] -port out1[0]
load net out1[1] -attr @rip(#000000) f[1] -pin m1 f[1] -port out1[1]
load net out1[2] -attr @rip(#000000) f[2] -pin m1 f[2] -port out1[2]
load net out1[3] -attr @rip(#000000) f[3] -pin m1 f[3] -port out1[3]
load net out2[0] -attr @rip(#000000) f[0] -pin m2 f[0] -port out2[0]
load net out2[1] -attr @rip(#000000) f[1] -pin m2 f[1] -port out2[1]
load net out2[2] -attr @rip(#000000) f[2] -pin m2 f[2] -port out2[2]
load net out2[3] -attr @rip(#000000) f[3] -pin m2 f[3] -port out2[3]
load net temp1[0] -attr @rip(#000000) a[0] -pin d1 a[0] -pin m1 a[0]
load net temp1[1] -attr @rip(#000000) a[1] -pin d1 a[1] -pin m1 a[1]
load net temp1[2] -attr @rip(#000000) a[2] -pin d1 a[2] -pin m1 a[2]
load net temp1[3] -attr @rip(#000000) a[3] -pin d1 a[3] -pin m1 a[3]
load net temp2[0] -attr @rip(#000000) b[0] -pin d1 b[0] -pin m2 a[0]
load net temp2[1] -attr @rip(#000000) b[1] -pin d1 b[1] -pin m2 a[1]
load net temp2[2] -attr @rip(#000000) b[2] -pin d1 b[2] -pin m2 a[2]
load net temp2[3] -attr @rip(#000000) b[3] -pin d1 b[3] -pin m2 a[3]
load net temp3[0] -attr @rip(#000000) a[0] -pin d2 a[0] -pin m1 b[0]
load net temp3[1] -attr @rip(#000000) a[1] -pin d2 a[1] -pin m1 b[1]
load net temp3[2] -attr @rip(#000000) a[2] -pin d2 a[2] -pin m1 b[2]
load net temp3[3] -attr @rip(#000000) a[3] -pin d2 a[3] -pin m1 b[3]
load net temp4[0] -attr @rip(#000000) b[0] -pin d2 b[0] -pin m2 b[0]
load net temp4[1] -attr @rip(#000000) b[1] -pin d2 b[1] -pin m2 b[1]
load net temp4[2] -attr @rip(#000000) b[2] -pin d2 b[2] -pin m2 b[2]
load net temp4[3] -attr @rip(#000000) b[3] -pin d2 b[3] -pin m2 b[3]
load netBundle @in1 4 in1[3] in1[2] in1[1] in1[0] -autobundled
netbloc @in1 1 0 2 NJ 60 NJ
load netBundle @in2 4 in2[3] in2[2] in2[1] in2[0] -autobundled
netbloc @in2 1 0 2 NJ 180 NJ
load netBundle @out1 4 out1[3] out1[2] out1[1] out1[0] -autobundled
netbloc @out1 1 3 1 NJ 80
load netBundle @out2 4 out2[3] out2[2] out2[1] out2[0] -autobundled
netbloc @out2 1 3 1 NJ 210
load netBundle @temp1 4 temp1[3] temp1[2] temp1[1] temp1[0] -autobundled
netbloc @temp1 1 2 1 N 60
load netBundle @temp2 4 temp2[3] temp2[2] temp2[1] temp2[0] -autobundled
netbloc @temp2 1 2 1 400 80n
load netBundle @temp3 4 temp3[3] temp3[2] temp3[1] temp3[0] -autobundled
netbloc @temp3 1 2 1 420 80n
load netBundle @temp4 4 temp4[3] temp4[2] temp4[1] temp4[0] -autobundled
netbloc @temp4 1 2 1 380 200n
levelinfo -pg 1 0 70 250 510 630
pagesize -pg 1 -db -bbox -sgen -100 0 740 270
show
fullfit
#
# initialize ictrl to current module Crossbar_2x2_4bit work:Crossbar_2x2_4bit:NOFILE
ictrl init topinfo |
