# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish
set -g theme_powerline_fonts yes
set -gx VIRTUAL_ENV_DISABLE_PROMPT true
set -x CLICOLOR 1
set -g theme_nerd_fonts yes

set -gx PYTHONSTARTUP ~/.pythonrc
