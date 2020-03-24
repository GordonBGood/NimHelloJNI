# example of native Nim code callable through JNI...
#
#    (c) Copyright 2020 W. Gordon Goodsman (GordonBGood)
#
#    See the file "copying.txt", included at the root of
#    this project, for details about the copyright.

#[ compile with a `cmd`/`sh` script as follows:
  nim c -c -d:noSignalHandler -d:danger -d:release --cpu:arm --os:android --noMain:on --nimcache:./arm native_jni
  nim c -c -d:noSignalHandler -d:danger -d:release --cpu:arm64 --os:android --noMain:on --nimcache:./arm64 native_jni
  nim c -c -d:noSignalHandler -d:danger -d:release --cpu:i386 --os:android --noMain:on --nimcache:./x86 native_jni
  nim c -c -d:noSignalHandler -d:danger -d:release --cpu:amd64 --os:android --noMain:on --nimcache:./x86_64 native_jni
]#
# Copied from jnim
# Specifically, from: https://github.com/yglukhov/jnim/blob/ec889fd4f58a8f587b53ee3b726de8189cc59769/src/private/jni_wrapper.nim
# type
#   jobject_base {.inheritable, pure.} = object
#   jobject* = ptr jobject_base
#   jstring* = ptr object of jobject
#   JNIEnv* = ptr JNINativeInterface
#   JNIEnvPtr* = ptr JNIEnv
#   JavaVM* = ptr JNIInvokeInterface
#   JavaVMPtr* = ptr JavaVM
import jni_wrapper

proc NimMain() {.importc.} # needed to initialize the GC, memory, and stack, etc.

# Automaticalled called just after the library is loaded...
proc JNI_OnLoad*(vmp: JavaVMPtr; reserved: pointer): jint {.cdecl,exportc,dynlib.} =
  NimMain() # won't hurt even when not needed for non-GC memory management!
  return JNI_VERSION_1_6

proc Java_com_example_nimhellojni_HelloJni_stringFromJNI*(env: JNIEnvPtr, thiz: jobject): jstring {.cdecl,exportc,dynlib.} =
  when defined(i386):
    let ABI = "x86"
  elif defined(amd64):
    let ABI = "x86_64"
  elif defined(arm):
    let ABI = "armeabi-v7a"
  elif defined(arm64):
    let ABI = "arm64-v8a"
  else:
    let ABI = "unknown"
  return env.NewStringUTF(env, "Hello from Nim native JNI! compiled for " & ABI & " .")
