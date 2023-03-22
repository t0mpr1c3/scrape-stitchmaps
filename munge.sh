#!/bin/sh

# statistical analysis of stitchmaps

# munge pattern text
tail -n+2 stitchmaps.csv|cut -d, -f4- -|sed 's/^"/ /;s/",".*/ /'|sed 's/ below/b/g;s/drop st/drop-st/ig;s/dip st/dip-st/ig;s/wrap \([0-9]*\) st/wrap-\1-st/ig;s/ wrapping yarn \([0-9]*\) times/-wrapping-yarn-\1-times/ig;s/ wrapping yarn /-wrapping-yarn-/ig;s/from//ig;s/ to / /ig;s/last//ig;s/ twice/ /ig;s/ times/ /ig;s/repeat//ig;s/multiple//ig;s/less//ig;s/more//ig;s/fewer//ig;s/next//ig;s/of//ig;s/plus//ig;s/ in / /ig;s/ st[s]*/ /ig;s/and//ig;s/\\n//g;s/Row[s]*//ig;s/Round[s]*//ig;s/(RS)//g;s/(WS)//g;s/(//g;s/)//g;s/\[//g;s/\]//g;s/\.//g;s/://g;s/*//g;s/ [0-9|-]* / /g;s/ [0-9|-]* / /g;s/ [0-9|-]* / /g;s/  / /g;s/  / /g;s/k[0-9]* /k /ig;s/p[0-9]* /p /ig;s/knit/k/ig;s/purl/p/ig;s/k1 /k /ig;s/p1 /p /ig;s/ [0-9]* / /g;s/ sl[0-9]* wy/ slwy/gi;s/ RPC/-RPC/g;s/ RC/-RC/g;s/ LC/-LC/g;s/ LPC/-LPC/g;s/ RT/-RT/g;s/ LT/-LT/g;s/ RPT/-RPT/g;s/ RSC/-RSC/g;s/ RSAC/-RSAC/g;s/ LSC/-LSC/g;s/ LSAC/-LSAC/g;s/ LPT/-LPT/g;s/bunny ears/bunny-ears/ig;s/yo/yo/ig;s/sl/sl/ig;s/bunny-ears yo/bunny-ears-yo/ig;s/bunny-ears back/bunny-ears-back/ig;s/,//g;s/  / /g;s/ k/ k/ig;s/ p/ p/ig;s/k[0-9]* /k /ig;s/p[0-9]* /p /ig;s/ gather/-gather/ig;s/ctr dbl /ctr-dbl-/ig;s/ twisted/-twisted/ig;s/wrap yarn/wrap-yarn/ig;s/ tbl/-tbl/ig;s/ thread/-thread/ig;s/ thru/-thru/ig;s/ right/-right/ig;s/ left/-left/ig;s/ inc /-inc /ig;s/ dec /-dec /ig'|tr [:upper:] [:lower:] > stitchmaps-munged.txt

# number of patterns
# 9263
wc -l stitchmaps-munged.txt

# number of unique stitches
# 227
cat stitchmaps-munged.txt|sed 's/ /\n/g'|awk '/[a-z]/'|sort|uniq > tokens.txt
wc -l tokens.txt

# frequency of stitches
for f in $(cat tokens.txt);do echo -n '$f,';grep -c $f stitchmaps-munged.txt;done|sort -rgk2 > stitch-freqs.csv