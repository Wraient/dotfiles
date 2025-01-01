temp_screenshot="/tmp/screenshot.png"
grimblast --freeze copysave area $temp_screenshot && restore_shader -f $temp_screenshot
gocr -g $temp_screenshot
