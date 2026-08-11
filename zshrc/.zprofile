
# Setting PATH for Python 3.10
# The original version is saved in .zprofile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
# export PATH

export PSPDEV=/usr/local/pspdev
##
# Your previous /Users/davidlakubu/.zprofile file was backed up as /Users/davidlakubu/.zprofile.macports-saved_2022-10-21_at_00:42:07
##

# MacPorts Installer addition on 2022-10-21_at_00:42:07: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.



# Added by Toolbox App
export PATH="$PATH:/usr/local/bin"
# export EMSDK_QUIET=1
# source "/Users/davidlakubu/emsdk/emsdk_env.sh"

# >>> coursier install directory >>>
export PATH="$PATH:/Users/davidlakubu/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<

export PATH="$PATH:/Users/davidlakubu/flutter/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PSPDEV/bin:$PATH"


# android
export JAVA_HOME="$HOME/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export NDK_HOME="$ANDROID_HOME/ndk/26.2.11394342"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
# Setting PATH for Python 3.11
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"
export PATH

# GEMINI_API_KEY — moved to pass store, do NOT commit secrets here
