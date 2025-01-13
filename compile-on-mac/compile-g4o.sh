#!/bin/zsh
export BUILD_REVISION="OUYA"

mkdir -p $HOME/git/
cd $HOME/git/
if [ ! -d "godot-for-ouya" ]; then git clone https://github.com/bherdm/godot-for-ouya.git; fi
cd godot-for-ouya
git checkout -b debian origin/debian

cd $HOME/git
if [ ! -d "godot-for-ouya-compile-automation" ]; then git clone https://github.com/bherdm/godot-for-ouya-compile-automation.git; fi
cd godot-for-ouya-compile-automation
cd compile-on-mac
./build-for-macos.sh
./build-for-android.sh