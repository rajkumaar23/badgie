# Install icons
icon_sizes = ['16', '32', '48', '64', '128']

foreach i : icon_sizes
    install_data (
        join_paths ('icons', i, meson.project_name () + '.svg'),
        install_dir: join_paths (get_option ('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
    )
    install_data (
        join_paths ('icons', i, meson.project_name () + '.svg'),
        install_dir: join_paths (get_option ('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps')
    )
endforeach


# Install our .desktop file so the Applications Menu will see it
install_data (
    join_paths (meson.project_name () + '.desktop'),
    install_dir: join_paths (get_option ('datadir'), 'applications')
)
    
# Install our .appdata.xml file so AppCenter will see it
install_data (
    join_paths (meson.project_name () + '.appdata.xml'),
    install_dir: join_paths (get_option ('datadir'), 'metainfo')
)
