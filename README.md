Nim Hello JNI \
[简体中文](README.zh.md)
=============
Nim Hello JNI is an Android sample that uses JNI to call C code from a Android Java Activity, with the C code generated from the Nim computer language instead of directly from C source files.

This has been adapted from [sample hello-jni android project](https://github.com/android/ndk-samples/tree/master/hello-jni) bye by translating the C file, NimHelloJNI/app/src/main/cpp/hello-jni.c to a Nim source file, NimHelloJNI/app/src/main/cpp/hello-jni.nim.

The changes have been to add the required .nim files, adding nim biuld script files (.cmd for windows and sh for linux), changing to using ndk-build instead of CMake, and adding an Android.mk file to do the native code building.

Notable discoveries were that the nimbase.h file needs to be made available for the native build process to work and that NimMain needs to be called before anything can be done with Nim strings as the Android and Nim Garbage Collection (GC) and memory management systems otherwise conflict (unless some alternate GC is used, but the best of those are still in development and not really recommended; using --gc:none will cause memory leaks if used extensively without a great deal of extra complexity in creating cstring's); these issues are documented various places in the Nim documentation and in the Nim forum, but this is the only place that everything is brought together.  As well, since the Nim produced .c files are hard coded for cpu architecture, we use separate directories for each cpu and make the build system select the correct one depending on the currently building architecture.  Further, the slickest way to run the NimMain `proc` is to run it in a JNI_OnLoad routine so it will automatically be run just once when the dynamic library file is loaded.

The build system used here where Nim is used to (`-c`) compile to .c files only and letting the build system turn those files into shared library files seems slightly simpler than using Nim to compile all the way to shared dynamic libraries to be just included by the build system as third party libraries, although doing that would also work and would eliminate the need for the `nimbase.h` file in the build files system.

Pre-requisites
--------------
- Android Studio 2.2+ with [NDK](https://developer.android.com/ndk/) bundle.

Getting Started
---------------
1. [Install Nim](https://nim-lang.org/install.html) for your platform.
3. [Download Android Studio](https://developer.android.com/sdk/index.html)
4. Install Android Studio as per the instructions.
5. Launch Android Studio.
6. Open *Tools>SDK Manager* and be sure the Android 12.0 (S) SDK Platform, version 31.0.0 SDK Build tools and NDK (Side by side latest sub version of 23) are installed.
7. Download this repository as a .zip file and extract it to a location of your choice.
8. Open that project location with Android Studio to open the project.
9. Note that the "nimbase.h" and "comping.txt" files in the "app/main/src/cpp" subfolder need to be updated to those from whatever version of the Nim compiler you are using (version 1.6.2 as the latest stable in this case) as from the Nim "lib" sub directory and the main Nim directory, respectively.
10. From the Android Studio terminal run "buildnim.cmd" (for Windows) or "buildnim.sh" (for Linux/OSX) to compile the Nim files to .c files.
11. Click *Files>Sync Project with Gradle Files*.
12. Click *Run/Run 'app'*.
13. Alternatively (and likely better for direct use), you can use "Build>Generate Signed Bundle/APK..." to generate an APK file that can be transfered to an Android phone and "side-loaded", giveing permission to do this from an unknown source.
14. The above involves generating a signing store and key store file (one time), which can be done almost automatically with Android Studio.
15. You could store the signing store key file in the mail directory of this project for ready use when the file is recompiled, but you likely don't want to publicize the key store file if you make a GitHub repository, as I have not done here.

There is a prebuilt signed (with a generated signing key not provided) APK installation file available in the `app/release` directory that can by installed (side-loaded) on Android smartphones if one trusts that it's contents reflect the source provided here; if one doesn't trust it, generate a new one as described by the alternate process described above.

Command Line
------------

You may want to install only the android studio command line tools for easier scripting.

*Installation*
```sh
## install nim

curl https://nim-lang.org/choosenim/init.sh -sSf | sh

# android command line tools

mkdir -p ~/android/cmdline-tools # the tools expect this structure

# if needed replace 'linux' with 'mac' or 'windows' (run in wsl)
curl $(curl -s https://developer.android.com/studio | grep -o "https://.*commandlinetools-linux.*_latest.zip") | jar xv && chmod +x cmdline-tools/bin/* && mv cmdline-tools android/cmdline-tools/tools

export PATH=$HOME/android/cmdline-tools/tools/bin:$PATH

# android packages (possibly find newer versions with sdkmanager --list)
yes | sdkmanager --install build-tools\;35.0.0
yes | sdkmanager --install platform-tools
yes | sdkmanager --install ndk\;27.2.12479018

*Build*

```sh
# clone repository
git clone https://github.com/GordonBGood/NimHelloJNI.git
cd NimHelloJNI

# add nim header
cp $HOME/.choosenim/toolchains/nim-2.2.0/lib/nimbase.h app/src/main

# Compile nim code to C
sh buildnim.sh

# Build apk package
gradle

# install apk to android device
ls app/release/app-release.apk

```


Screenshots
-----------
![screenshot](screenshot.png)

License
-------
Copyright (C) 2020 W. Gordon Goodsman (GordonBGood). All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[ MIT license: http://www.opensource.org/licenses/mit-license.php ]
