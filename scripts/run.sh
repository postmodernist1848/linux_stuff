#! /bin/bash

set -euo pipefail

# A simple script to compile and run files in different programming languages

echocmd() {
    echo "$@"
    "$@"
}

run() {
    time $(realpath "$1") "${@:2}"
}

if [ $# -lt 1 ]; then 
echo "Error: not enough arguments." > /dev/stderr
exit 1
else
    filepath="$1"
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    exe="${filename%.*}"

    for (( dashdashi=1; dashdashi <= "$#"; dashdashi++ )); do
        if [[ ${!dashdashi} == "--" ]]; then
            break
        fi
    done

    compilation_args=("${@:2:dashdashi - 2}")
    runtime_args=("${@:dashdashi + 1}")

    # NOTE: this is how to use arrays:
    # printargs "${compilation_args[@]}"
    # printargs "${runtime_args[@]}"

    case "$extension" in
        py)
            time python "$filepath" "${compilation_args[@]}" -- "${runtime_args[@]}"
            exit $?
            ;;
        S)
            echocmd as "$filepath" -o "$exe.o" "${compilation_args[@]}" &&
            echocmd ld -o $exe "$exe.o" && 
            run $exe "${runtime_args[@]}"
            exit $?
            ;;
        asm)
            echocmd nasm "$filepath" -g -felf64 -o "$exe.o" "${compilation_args[@]}" &&
            echocmd ld -o "$exe" "$exe.o" && 
            run $exe "${runtime_args[@]}"
            exit $?
            ;;
        hs)
            if grep "main =" "$filepath"; then
                runhaskell "$@"
            else
                ghci -W "$@"
            fi
            exit $?
            ;;
        c | cpp)
            [ $extension == 'c' ] && cc=gcc || cc=g++
            if [ ! -z $(find . -maxdepth 1 -name Makefile | xargs) ]; then
                echocmd make && time "$exe" "${runtime_args[@]}"
                exit $?
            else
                CFLAGS="-Wall -Wextra -lm"
                if echocmd "$cc" "$filepath" "${compilation_args[@]}" $CFLAGS -o "$exe"; then 
                    run "$exe"
                    exitcode=$?
                    rm "$exe" "${runtime_args[@]}"
                    exit $exitcode
                else 
                    exit $?
                fi
            fi
            ;;
        cs) 
            if echocmd mcs "$@"; then
                mono "$exe.exe"
                rm "$exe.exe"
            fi
            ;;
        rs)
            # 'detecting' a cargo project
            abspath=$(realpath "$filename")
            projectdir=$(echo "$abspath" | awk -F 'src' '{print $1}')
            if [[ -f $projectdir/Cargo.toml ]]; then
                cargo run
            else 
                if echocmd rustc "${compilation_args[@]}"; then
                    run "$exe"
                    rm $exe
                fi
            fi
            ;;
        go)
            time go run "$@"
            ;;
        java)
            javac -cp $(dirname "$filepath") "$filepath" "${compilation_args[@]}" &&
            java -cp $(dirname "$filepath") $(basename "$filepath") "${runtime_args[@]}"
            exit $?
            ;;
        sh)
            time $@
            exit $?
            ;;
        v)
            iverilog -g2001 "$filepath" "${compilation_args[@]}" &&
            time ./a.out "${runtime_args[@]}"
            exit $?
            ;;
        *)
            echo "Unknown filetype \`$extension\`" > /dev/stderr
            ;;
    esac
fi
