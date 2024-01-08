function berry -a mode -a project -d 'Run the verification tests for a project'

  if string match -q '*/arvr/python/device_control' $project
      set -l target dcl_test.0
      tmux send-keys -t $target 'clear' ENTER
      tmux send-keys -t $target 'arc lint --never-apply-patches; '
      tmux send-keys -t $target 'pyre -l .; '
      tmux send-keys -t $target 'buck test @arvr/mode/mac/rosetta/opt //arvr/python/device_control/...;'
      tmux send-keys -t $target ENTER
  else if string match -q '*/arvr/python/daco' $project
      set -g target daco_test.0
      set -g flavor 'ar_slam:ar_slam -- ui'
      set -g envv ''
      if string match -qr 'fbsource-daco-web' $project
          set -g target daco_web_.0
          set -g flavor 'ar_slam_web:ar_slam_web -- -v --config=config:///flavors/dragonfly.yaml web --port 8080 --host 0.0.0.0'
          set -g envv 'DACO_DB_DIR=~/daco'
          # set -g envv 'DACO_PREFLIGHT_CHECKS=DISABLE DACO_DB_DIR=~/daco'
      end

      tmux send-keys -t $target C-c C-c
      tmux send-keys -t $target 'clear' ENTER

      if string match -q 'test' $mode
          tmux send-keys -t $target 'arc lint --never-apply-patches; '
          tmux send-keys -t $target 'pyre -l flavors/ar_slam_web; '
          tmux send-keys -t $target 'buck test @arvr/mode/mac/rosetta/opt //arvr/python/daco/flavors/ar_slam_web/... --always-exclude --exclude slow; '
      else if string match -q 'run' $mode
          tmux send-keys -t $target "$envv buck run @arvr/mode/mac/rosetta/opt //arvr/python/daco/flavors/$flavor; "
      end
      tmux send-keys -t $target ENTER 
      set -e target
      set -e flavor
      set -e envv
  end

end
