#!/usr/bin/env bash



MODEL="all"
OPTIONS=$(getopt -o hm:d -l help,model:,dir -- "$@")

if [ $? -ne 0 ]; then
  echo "getopt error"
  exit 1
fi

eval set -- $OPTIONS


while true; do
  case "$1" in
    -h|--help) HELP=1
    echo "Downloading torch models"
    echo "-m --model name of model (default all)"
    echo "-d --dir download directory (default current)"
    echo "----------------- Model List -------------------------"
    echo "0 - all"
    echo "1 - fcnalex_pascal_fc7"
    echo "2 - alex_full_conv_fc7"
    exit 1;;
    -m|--model) MODEL="$2" ; shift ;;
    -d|--dir) FILE="$3" ; shift ;;
    #-g|--foo)  FOO=1 ;;
    #-b|--bar)  BAR=1 ;;
    --)        shift ; break ;;
    *)         echo "unknown option: $1" ; exit 1 ;;
  esac
  shift
done

if [ $# -ne 0 ]; then
  echo "unknown option(s): $@"
  exit 1
fi

#echo "model : $MODEL"
#echo "help: $HELP"
#echo "file: $FILE"
#echo "foo: $FOO"
#echo "bar: $BAR"

if [ $MODEL != all ] && [ $MODEL != alex_std ] && [ $MODEL != alex_fullconv_992 ] && [ $MODEL != alex_fullconv_1000 ]; then
    echo "unknown model(s): $MODEL"
    exit 1
fi
# ----------------------------------------------------------------------
echo "Downloading torch models ..."




#if [ -f "alexnet_full_conv.net" ]; then
#  rm alexnet_full_conv.net
#fi
#wget https://www.dropbox.com/s/wmwx8j3zrihh1z5/alexnet_full_conv.net


if [ $MODEL == all ] || [ $MODEL == fcnalex_pascal_fc7 ]; then
    if [ -f "fcnalex_pascal_fc7.net" ]; then
        rm fcnalex_pascal_fc7.net
    fi
    wget https://www.dropbox.com/s/1gv3hofpgi0gqfm/fcnalex_pascal_fc7.net
fi

if [ $MODEL == all ] || [ $MODEL == fcnalex_pascal ]; then
    if [ -f "alex_full_conv_fc7.net" ]; then
        rm alex_full_conv_fc7.net
    fi
    wget https://www.dropbox.com/s/fn5hcrowwk1kh5h/th_model_full_conv_fc7.net
fi

#echo "Unzipping..."
#tar -xf caffe_ilsvrc12.tar.gz && rm -f caffe_ilsvrc12.tar.gz

echo "Done."

