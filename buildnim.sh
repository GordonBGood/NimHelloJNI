# I'm not sure this is correct and don't have a Bash shell to check it...

# the androidNDK define as used below turns on the ability so that echo text is
# output to the Android Logcat logging facilities, which could be handy in assisting debugging...
nim c -c -d:noSignalHandler -d:danger -d:release -d:androidNDK \
--cpu:arm --os:android --noMain:on \
--nimcache:app/src/main/cpp/arm app/src/main/nim/hello_jni
nim c -c -d:noSignalHandler -d:danger -d:release -d:androidNDK \
--cpu:arm64 --os:android --noMain:on \
--nimcache:app/src/main/cpp/arm64 app/src/main/nim/hello_jni
nim c -c -d:noSignalHandler -d:danger -d:release -d:androidNDK \
--cpu:i386 --os:android --noMain:on \
--nimcache:app/src/main/cpp/x86 app/src/main/nim/hello_jni
nim c -c -d:noSignalHandler -d:danger -d:release -d:androidNDK \
--cpu:amd64 --os:android --noMain:on \
--nimcache:app/src/main/cpp/x86_64 app/src/main/nim/hello_jni
