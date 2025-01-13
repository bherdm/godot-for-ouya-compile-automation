#!/bin/zsh
cd $HOME/git/godot-for-ouya

# Get logic core count
threads=$(sysctl -n hw.logicalcpu)
compile_cores=$((threads / 2))
if [ $compile_cores -ge 6 ]; then
    compile_cores+=2
elif [ $compile_cores -gt 1 ]; then
    compile_cores+=1
fi

# Build the editor for macOS
scons platform=osx target=release_debug bits=64 -j$compile_cores

cp -r misc/dist/osx_tools.app ./godot-for-ouya.app
mkdir -p godot-for-ouya.app/Contents/MacOS
cp bin/godot.osx.opt.tools.64 godot-for-ouya.app/Contents/MacOS/Godot
chmod +x godot-for-ouya.app/Contents/MacOS/Godot
mv godot-for-ouya.app bin/

# Build macOS templates
scons platform=osx tools=no target=release -j$compile_cores
scons platform=osx tools=no target=release_debug -j$compile_cores

cp -r misc/dist/osx_template.app ./osx_template.app
mkdir -p osx_template.app/Contents/MacOS
cp bin/godot.osx.opt.64 osx_template.app/Contents/MacOS/godot_osx_release.64
cp bin/godot.osx.opt.debug.64 osx_template.app/Contents/MacOS/godot_osx_debug.64
chmod +x osx_template.app/Contents/MacOS/godot_osx*

zip -q -9 -r osx.zip osx_template.app

mv osx_template.app bin/
mv osx.zip bin/