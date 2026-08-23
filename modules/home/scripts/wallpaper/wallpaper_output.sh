#! /usr/bin/env bash
usage() { echo "Usage: $0 -o output1,output2 -i image.png; }

while getopts ":o:i:" o; do
    case "${o}" in
        o)
            s=${OPTARG}
            ((s == 45 || s == 90)) || usage
            ;;
        i)
            p=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
