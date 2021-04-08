#!/bin/bash

# file: 01b_setup_bash_aliases.sh

if [ "$(grep bash_aliases ~/.bashrc)" == "" ]; then
echo Adding call to ~/.bash_aliases from ~/.bashrc
cat >> ~/.bashrc << EOF

# - - - - - - - - -
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF
fi

mkdir -p ~/bin
cat >> ~/.bash_aliases << EOF

# - - - - - - - - -
export PATH=~/bin:\${PATH}
EOF
