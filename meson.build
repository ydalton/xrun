project(
  'searcher',
  'vala',
  version: '0.1',
  default_options: [
    'optimization=2'
  ]
)

searcher_deps = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gio-2.0'),
  dependency('gio-unix-2.0'),
  dependency('gtk+-3.0')
]

gnome = import('gnome')

searcher_sources = [
  'Searcher.vala',
  'Window.vala',
  'DesktopFileSearch.vala'
]

searcher_sources += gnome.compile_resources('searcher-gresources',
                                            'searcher.gresources.xml')

executable(
  meson.project_name(),
  searcher_sources,
  dependencies: searcher_deps
)