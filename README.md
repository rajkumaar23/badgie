# Badgie
Say NO to hardcoding! Generate badges for your android app's README with realtime data from Google Playstore such as Version, Number of Installs, Rating etc

![Badgie Screenshot](data/screenshots/1.png)

## Building, and Installation

Ensure you have `meson` and `valac` installed. Make sure you have all the dependencies mentioned in [meson.build](meson.build)

    meson build --prefix=/usr
    cd build
    ninja

To install,

    sudo ninja install
    com.github.rajkumaar23.badgie
