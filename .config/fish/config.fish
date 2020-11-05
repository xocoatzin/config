set -g theme_powerline_fonts yes
set -gx VIRTUAL_ENV_DISABLE_PROMPT true
set -x CLICOLOR 1
set -g theme_nerd_fonts yes
set -x GPG_TTY (tty)


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/atorresgomez/google-cloud-sdk/path.fish.inc' ]; . '/Users/atorresgomez/google-cloud-sdk/path.fish.inc'; end
