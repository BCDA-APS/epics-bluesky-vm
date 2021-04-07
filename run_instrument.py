# - - - - - - - - - - - - - - - -
"start bluesky in IPython session"

import os
import sys
sys.path.append(os.path.join(os.environ["HOME"], "bluesky"))

from instrument.collection import *
