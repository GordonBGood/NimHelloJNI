:: the androidNDK define as used below turns on the ability so that echo text is
:: output to the Android Logcat logging facilities, which could be handy in assisting debugging...

:: remove all the results of older bulid's...
rd /q /s app/src/main/cpp/arm
rd /q /s app/src/main/cpp/arm64
rd /q /s app/src/main/cpp/x86
rd /q /s app/src/main/cpp/x86_64

:: compile for each of the ANDROID_ABI's...
nim c -c -d:noSignalHandler -d:danger -d:release -d:androidNDK ^
--cpu:arm --os:android --noMain:on ^
--nimcache:app/src/main/cpp/arm app/src/main/nim/hello_jni
nim c -c -d:noSignalHandler -d:danger -d:release -d:androidNDK ^
--cpu:arm64 --os:android --noMain:on ^
--nimcache:app/src/main/cpp/arm64 app/src/main/nim/hello_jni
nim c -c -d:noSignalHandler -d:danger -d:release -d:androidNDK ^
--cpu:i386 --os:android --noMain:on ^
--nimcache:app/src/main/cpp/x86 app/src/main/nim/hello_jni
nim c -c -d:noSignalHandler -d:danger -d:release -d:androidNDK ^
--cpu:amd64 --os:android --noMain:on ^
--nimcache:app/src/main/cpp/x86_64 app/src/main/nim/hello_jni
