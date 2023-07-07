#!/bin/bash

Help () {
    echo "Encodes or decodes a string in a chemistry cipher. Each element of the periodic table represents either an alphabet character or an ASCII character."
    echo
    echo "Usage: ./chemistry.sh --<ciper> --<en/decode> <message>"
    echo
    echo "--help    -h  Prints this help message."
    echo "--simple  -s  Uses the simple chemistry cipher (A = 1 = H, B = 2 = He... Z = 26 = Fe)"
    echo "--ascii   -a  Uses the ASCII chemistry cipher (A = 65 = Tb, B = 66 = Dy... ~ = 126 wrap around to 8 = O)"
    echo "--encode  -e  Encode your message."
    echo "--decode  -d  Decode your message."
    echo "--message -m  Message."
    echo
    echo "Example: ./chemistry.sh --simple --encode --message \"Hello There\!\""
    echo "Example: ./chemistry.sh -a -d -m \"It's over Anakin...\""
    echo
    echo "If only a message is provided, then the program will encode it with the simple cipher."
    echo "A note about ASCII. At the time of writing the highest atomic number on the periodic table is 118 (Og). The characters from w to ~ take up 119-126 (127 is DEL, not really used anymore)."
    echo "The last range of characters wrap around to 1 - 8, as those also aren't really used anymore. Plus, they fit right before 9 (TAB), which is used."
}

SimpleEncode () {
    message=${1^^}

    declare -A elements
    elements[A]=H
    elements[B]=He
    elements[C]=Li
    elements[D]=Be
    elements[E]=B
    elements[F]=C
    elements[G]=N
    elements[H]=O
    elements[I]=F
    elements[J]=Ne
    elements[K]=Na
    elements[L]=Mg
    elements[M]=Al
    elements[N]=Si
    elements[O]=P
    elements[P]=S
    elements[Q]=Cl
    elements[R]=Ar
    elements[S]=K
    elements[T]=Ca
    elements[U]=Sc
    elements[V]=Ti
    elements[W]=V
    elements[X]=Cr
    elements[Y]=Mn
    elements[Z]=Fe
    elements[" "]=" "
    elements[.]=.
    elements[,]=,
    elements[";"]=";"
    elements[:]=:
    elements[-]=-
    elements[?]=?
    elements["!"]="!"
    elements["'"]="'"

    encoded=
    for ((i=0; i<${#message}; i++ )); do
        encoded+=${elements[${message:$i:1}]}
    done

    echo $encoded
}

SimpleDecode () {
    message=$1

    declare -A elements
    elements[H]=A
    elements[He]=B
    elements[Li]=C
    elements[Be]=D
    elements[B]=E
    elements[C]=F
    elements[N]=G
    elements[O]=H
    elements[F]=I
    elements[Ne]=J
    elements[Na]=K
    elements[Mg]=L
    elements[Al]=M
    elements[Si]=N
    elements[P]=O
    elements[S]=P
    elements[Cl]=Q
    elements[Ar]=R
    elements[K]=S
    elements[Ca]=T
    elements[Sc]=U
    elements[Ti]=V
    elements[V]=W
    elements[Cr]=X
    elements[Mn]=Y
    elements[Fe]=Z
    elements[" "]=" "
    elements[.]=.
    elements[,]=,
    elements[";"]=";"
    elements[:]=:
    elements[-]=-
    elements[?]=?
    elements["!"]="!"
    elements["'"]="'"

    decoded=
    for ((i=0; i<${#message}; i++ )); do
        char=
        if [ $i -eq ${#message} ]; then
            char=${message:$i:1}
        else
            j=$i+1
            case ${message:$j:1} in
                [[:lower:]])       char=${message:$i:2};;
                *)                  char=${message:$i:1};;
            esac
        fi

        decoded+=${elements[${char}]}
    done

    echo $decoded
}

ASCIIEncode () {
    declare -A elements
    elements[119]="H"
    elements[120]="He"
    elements[121]="Li"
    elements[122]="Be"
    elements[123]="B"
    elements[124]="C"
    elements[125]="N"
    elements[126]="O"
    elements[9]="F"
    elements[10]="Ne"
    elements[11]="Na"
    elements[12]="Mg"
    elements[13]="Al"
    elements[14]="Si"
    elements[15]="P"
    elements[16]="S"
    elements[17]="Cl"
    elements[18]="Ar"
    elements[19]="K"
    elements[20]="Ca"
    elements[21]="Sc"
    elements[22]="Ti"
    elements[23]="V"
    elements[24]="Cr"
    elements[25]="Mn"
    elements[26]="Fe"
    elements[27]="Co"
    elements[28]="Ni"
    elements[29]="Cu"
    elements[30]="Zn"
    elements[31]="Ga"
    elements[32]="Ge"
    elements[33]="As"
    elements[34]="Se"
    elements[35]="Br"
    elements[36]="Kr"
    elements[37]="Rb"
    elements[38]="Sr"
    elements[39]="Y"
    elements[40]="Zr"
    elements[41]="Nb"
    elements[42]="Mo"
    elements[43]="Tc"
    elements[44]="Ru"
    elements[45]="Rh"
    elements[46]="Pd"
    elements[47]="Ag"
    elements[48]="Cd"
    elements[49]="In"
    elements[50]="Sn"
    elements[51]="Sb"
    elements[52]="Te"
    elements[53]="I"
    elements[54]="Xe"
    elements[55]="Cs"
    elements[56]="Ba"
    elements[57]="La"
    elements[58]="Ce"
    elements[59]="Pr"
    elements[60]="Nd"
    elements[61]="Pm"
    elements[62]="Sm"
    elements[63]="Eu"
    elements[64]="Gd"
    elements[65]="Tb"
    elements[66]="Dy"
    elements[67]="Ho"
    elements[68]="Er"
    elements[69]="Tm"
    elements[70]="Yb"
    elements[71]="Lu"
    elements[72]="Hf"
    elements[73]="Ta"
    elements[74]="W"
    elements[75]="Re"
    elements[76]="Os"
    elements[77]="Ir"
    elements[78]="Pt"
    elements[79]="Au"
    elements[80]="Hg"
    elements[81]="Tl"
    elements[82]="Pb"
    elements[83]="Bi"
    elements[84]="Po"
    elements[85]="At"
    elements[86]="Rn"
    elements[87]="Fr"
    elements[88]="Ra"
    elements[89]="Ac"
    elements[90]="Th"
    elements[91]="Pa"
    elements[92]="U"
    elements[93]="Np"
    elements[94]="Pu"
    elements[95]="Am"
    elements[96]="Cm"
    elements[97]="Bk"
    elements[98]="Cf"
    elements[99]="Es"
    elements[100]="Fm"
    elements[101]="Md"
    elements[102]="No"
    elements[103]="Lr"
    elements[104]="Rf"
    elements[105]="Db"
    elements[106]="Sg"
    elements[107]="Bh"
    elements[108]="Hs"
    elements[109]="Mt"
    elements[110]="Ds"
    elements[111]="Rg"
    elements[112]="Cn"
    elements[113]="Nh"
    elements[114]="Fl"
    elements[115]="Mc"
    elements[116]="Lv"
    elements[117]="Ts"
    elements[118]="Og"
    elements[" "]=" "

    echo "in progress"
}

ASCIIDecode () {
    echo "in progress"
}

# Start of program
if [ $# -eq 0 ]; then
    echo "Need at least one argument. Try ./chemistry.sh -h"
    exit 1
fi

message=
useAscii=false
useDecode=false

# Process flags
while [ "$1" != "" ]; do
    case $1 in
    -h | --help)
        Help
        exit 1
        ;;
    -s | --simple)
        useAscii=false
        ;;
    -a | --ascii)
        useAscii=true
        ;;
    -e | --encode)
        useDecode=false
        ;;
    -d | --decode)
        useDecode=true
        ;;
    -m | --message)
        shift
        message=$1
        ;;
    *) # Default
        Help
        exit 1
        ;;
    esac
    shift
done

if $useAscii; then
    if $useDecode; then
        ASCIIDecode "$message"
    else
        ASCIIEncode "$message"
    fi
else
    if $useDecode; then
        SimpleDecode "$message"
    else
        SimpleEncode "$message"
    fi
fi

exit 0

#test1=$1
#SimpleEncode "$test1"
