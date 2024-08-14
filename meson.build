project(
  'searcher',
  'vala',
)

searcher_deps = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gtk+-3.0')
]

gnome = import('gnome')

searcher_sources = [
  'Searcher.vala',
  'Window.vala'
]

searcher_sources += gnome.compile_resources('searcher-gresources',
                                            'searcher.gresources.xml')

executable(
  meson.project_name(),
  searcher_sources,
  dependencies: searcher_deps
)