# Project name, programming language and version
project (
    'com.github.rajkumaar23.badgie',
    'vala', 'c',
    version: '0.1.4'
)


# Translation module
i18n = import ('i18n')

# Gnome module
gnome = import ('gnome')

# Project arguments
add_project_arguments (
    '-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name ()),
    language: 'c'
)

# Listing dependencies
dependencies = [
    dependency ('glib-2.0'),
    dependency ('gtk+-3.0'),
    dependency ('libsoup-2.4'),
    dependency ('gee-0.8'),
    dependency ('gdk-pixbuf-2.0')
]

subdir ('src')

# Executable
executable (
    meson.project_name (),
    sources,
    dependencies: dependencies,
    install: true
)

subdir ('data')

meson.add_install_script ('meson/post_install.py')
