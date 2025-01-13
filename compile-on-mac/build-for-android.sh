#!/bin/zsh
export BUILD_REVISION="OUYA"

# Get logic core count
threads=$(sysctl -n hw.logicalcpu)
compile_cores=$((threads / 2))
if [ $compile_cores -ge 6 ]; then
    compile_cores+=2
elif [ $compile_cores -gt 1 ]; then
    compile_cores+=1
fi

# Set up Java
mkdir -p $HOME/git/godot-for-ouya/bin/Java
cd $HOME/git/godot-for-ouya/bin/Java
if [ ! -e "jdk8.tar.gz" ]; then
    curl -L -o "jdk8.tar.gz" "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u432-b06/OpenJDK8U-jdk_x64_mac_hotspot_8u432b06.tar.gz"
fi
if [ -d "jdk8u432-b06" ]; then
    rm -rf jdk8u432-b06
fi
tar -xzf jdk8.tar.gz
export ANDROID_JAVA_HOME="$HOME/git/godot-for-ouya/bin/Java/jdk8u432-b06/Contents/Home"
export JAVA_HOME="$HOME/git/godot-for-ouya/bin/Java/jdk8u432-b06/Contents/Home"

# Set up Android SDK
mkdir -p $HOME/git/godot-for-ouya/bin/Android/sdk/cmdline-tools
cd $HOME/git/godot-for-ouya/bin/Android/
curl -L -o "sdk_tools_8.0.zip" "https://dl.google.com/android/repository/commandlinetools-mac-9123335_latest.zip"
unzip -q sdk_tools_8.0.zip
mv cmdline-tools $HOME/git/godot-for-ouya/bin/Android/sdk/cmdline-tools/8.0
cd $HOME/git/godot-for-ouya/bin/Android/sdk/cmdline-tools/8.0/bin
./sdkmanager "platforms;android-23" "platform-tools" "build-tools;26.0.1" "ndk;17.2.4988734" "sources;android-23"
./sdkmanager --licenses
export ANDROID_HOME="$HOME/git/godot-for-ouya/bin/Android/sdk"
export ANDROID_NDK_ROOT="$HOME/git/godot-for-ouya/bin/Android/sdk/ndk/17.2.4988734"
export ANDROID_NDK_HOME="$HOME/git/godot-for-ouya/bin/Android/sdk/ndk/17.2.4988734"

# Build OUYA templates
cd $HOME/git/godot-for-ouya

scons platform=android target=debug android_arch=armv7 -j$compile_cores
scons platform=android target=release android_arch=armv7 -j$compile_cores
cd platform/android/java
./gradlew build