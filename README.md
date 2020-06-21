<div align="center">
  <p><img src="data/screenshots/1.png"/></p>
  <h1>Badgie</h1>
  <p>
    Say NO to hardcoding!
    <br>
    Generate badges for your android app's README with realtime data
    <br>
    from Google Playstore such as Version, Number of Installs, Rating etc
  </p>
</div>

<div align="center">
  <a href='https://appcenter.elementary.io/com.github.rajkumaar23.badgie'>
    <img src="https://appcenter.elementary.io/badge.svg"/>
  </a>
  <p>This app is available on the elementary OS AppCenter.</p>
  <a href='https://www.behance.net/ragulraj1'>
    <img src="https://img.shields.io/static/v1?label=Logo%20Designed%20By&message=Ragul%20Raj&color=important&logo=behance"/>
  </a>
</div>

# Install it from source

You can of course download and install this app from source.

## Dependencies

Ensure you have these dependencies installed

* granite
* gtk+-3.0
* libsoup-2.4
* gee-0.8
* gdk-pixbuf-2.0

## Install, build and run

Run `meson` build to configure the build environment. Change to the build directory and run `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`, then execute with `com.github.rajkumaar23.badgie`

    sudo ninja install
    com.github.rajkumaar23.badgie
