#! /bin/sh
# version @(#) giftogfx.sh 1.2@(#) 02/05/22 16:07:00 Meteorage

# This little script transforms a gif file in a special poscript format
# useable in catsview.
# $1 the entry file in GIF
# $2 the output file in "special" PS

# PATH=$PATH:/usr/local/bin:/usr/local/pbm/bin
# export PATH
ifile=""
ofile=""

usage()
{
echo Usage: $0 \(-i ifile.gif -o ofile.ps \) 1>&2
exit 1
}

while test $# -ge 1
do
       case $1 in
                -i) 	ifile=$2
                        shift;shift
                        ;;

                -o)     ofile=$2
                        shift;shift
                        ;;

                *)      ifile=$1
                        ofile=$2
                        shift;shift
                        ;;
        esac
done

if test -z "$ifile"
then
        usage
fi

jpegtopnm $ifile >/tmp/giftoppm.$$
pnmtops -noturn /tmp/giftoppm.$$ >/tmp/giftoppm1.$$
sed '/%/ D' /tmp/giftoppm1.$$ | sed '/translate/ D' | sed '/gsave/ D' | sed '/grestore/ D' | sed '/showpage/ D' > $ofile
/usr/bin/rm -f /tmp/giftoppm.$$ /tmp/giftoppm1.$$

