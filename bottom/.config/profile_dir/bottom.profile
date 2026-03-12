
if [ "$(command -v btm)" ]; then
    alias btm-sensor='btm -C ~/.config/bottom/sensor.toml'
    alias top='btm -C ~/.config/bottom/sensor.toml'
fi
