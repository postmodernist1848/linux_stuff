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
    filepath=$1
    filename=$(basename -- "$1")
    extension="${filename##*.}"

    for (( dashdashi=1; dashdashi <= "$#"; dashdashi++ )); do
        if [[ ${!dashdashi} == "--" ]]; then
            break
        fi
    done

    
    #TODO: healthy version with all args preserved
    compilation_args=${@:2:dashdashi - 2}
    runtime_args=${@:dashdashi + 1}
    #printargs "$@"
    #printargs ${compilation_args@Q}
    #printargs ${@:2:dashdashi - 2}
    #exit 1

    case $extension in
        py)
            time python $filepath $compilation_args -- $runtime_args 
            exit $?
            ;;
        S)
            exe="${f%.*}"
            echocmd as $@ -o "$exe.o" $compilation_args &&
            ld -o $exe "$exe.o" && time $exe $runtime_args
            exit $?
            ;;
        #TODO: every lang below
        asm)
            exe="${f%.*}"
            echocmd nasm $@ -g -felf64 &&
            ld -o $exe "$exe.o" && time $exe
            exit $?
            ;;
        hs)
            if grep "main = do" $filepath; then
                runhaskell $@
            else
                ghci -W $@
            fi
            exit $?
            ;;
        c | cpp)
            [ $extension == 'c' ] && cc=gcc || cc=g++
            exe="${filename%.*}"
            if [ ! -z $(find . -maxdepth 1 -name Makefile | xargs) ]; then
                echocmd make && time $exe
                exit $?
            else
                CFLAGS="-Wall -Wextra -lm"
                if echocmd $cc $filepath $compilation_args $CFLAGS -o $exe; then 
                    time ./$exe
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
            abspath=$(realpath $filename)
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
        go)
            time go run $@
            ;;
        java)
            exe="${f%.*}"
            javac -cp $(dirname $filepath) $filepath &&
            java -cp $(dirname $filepath) $(basename $filepath) ${@:2}
            ;;
        sh)
            time $@
            exit $?
            ;;
        v)
            iverilog -g2001 $filepath &&
            time ./a.out
            exit $?
            ;;
        *)
            echo "Unknown filetype \`$extension\`" > /dev/stderr
            ;;
    esac
fi
