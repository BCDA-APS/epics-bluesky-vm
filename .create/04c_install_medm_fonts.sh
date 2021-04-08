#!/bin/bash

# file: 04c_install_medm_fonts.sh

if [ "" == "${EPICS_EXT}" ]; then
    echo EPICS_ROOT not defined.
    source /usr/local/epics/setup_base_env.sh
    source /usr/local/epics/setup_extensions_env.sh
fi

# fonts
cd ${EPICS_EXT}
# ! MEDM widget font aliases
# !
# ! add to /usr/X11R6/lib/X11/fonts/misc/fonts.alias
# !     or /usr/share/fonts/X11/misc/fonts.alias
# !
cat > ./medm_fonts.alias << EOF

widgetDM_4 5x7
widgetDM_6 widgetDM_4
widgetDM_8 5x8
widgetDM_10 widgetDM_8
widgetDM_12 6x10
widgetDM_14 6x12
widgetDM_16 7x14
widgetDM_18 widgetDM_16
widgetDM_20 8x16
widgetDM_22 widgetDM_20
widgetDM_24 10x20
widgetDM_30 widgetDM_24
widgetDM_36 12x24
widgetDM_40 widgetDM_36
widgetDM_48 widgetDM_40
widgetDM_60 widgetDM_48
EOF

sudo cp /usr/share/fonts/X11/misc/fonts.alias{,.original}
sudo cat ${EPICS_EXT}/medm_fonts.alias | sudo tee -a /usr/share/fonts/X11/misc/fonts.alias
xset fp rehash
