#! /bin/bash
# A simple script to compile and run files in different programming languages

echocmd() {
    echo "$@"
    "$@"
}

if [ $# -lt 1 ]; then 
echo "Error: not enough arguments." > /dev/stderr
exit 1
else
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    f=$1
    case $extension in
        py)
            time python $@
            exit $?
            ;;
        S)
            exe="${f%.*}"
            echocmd as $@ -o "$exe.o" &&
            ld -o $exe "$exe.o" && time $exe
            exit $?
            ;;
        asm)
            exe="${f%.*}"
            echocmd nasm $@ -g -felf64 &&
            ld -o $exe "$exe.o" && time $exe
            exit $?
            ;;
        hs)
            if grep "main = do" $f; then
                runhaskell $@
            else
                ghci -W $@
            fi
            exit $?
            ;;
        c | cpp)
            [ $extension == 'c' ] && cc=gcc || cc=g++
            exe="${f%.*}"
            if [ ! -z $(find . -maxdepth 1 -name Makefile | xargs) ]; then
                echocmd make && time $exe
                exit $?
            else
                CFLAGS="-Wall -Wextra -lm"
                echo $cc $@ $CFLAGS -o $exe 
                if echocmd $cc $@ $CFLAGS -o $exe; then 
                    time $exe
                    exitcode=$?
                    rm $exe 
                    exit $exitcode
                else 
                    exit $?
                fi
            fi
            ;;
        cs) 
            exe="${f%.*}.exe"
            if echocmd mcs $@; then
                mono $exe
                rm $exe
            fi
            ;;
        rs)
            # 'detecting' a cargo project
            abspath=$(realpath $f)
            projectdir=$(echo $abspath | awk -F 'src' '{print $1}')
            if [[ -f $projectdir/Cargo.toml ]]; then
                cargo run
            else 
                exe="${f%.*}"
                if echocmd rustc $@; then
                    $exe
                    rm $exe
                fi
            fi
            ;;
        sh)
            time $@
            exit $?
            ;;
        *)
            echo "Unknown filetype \`$extension\`" > /dev/stderr
            ;;
    esac
fi
