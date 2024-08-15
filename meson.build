project(
  'xrun',
  'vala',
  version: '0.1',
  default_options: [
    'optimization=2'
  ]
)

xrun_deps = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gio-2.0'),
  dependency('gtk+-3.0')
]

gnome = import('gnome')

xrun_sources = [
  'XRun.vala',
  'Window.vala',
]

xrun_sources += gnome.compile_resources('xrun-gresources',
                                            'xrun.gresources.xml')

executable(
  meson.project_name(),
  xrun_sources,
  dependencies: xrun_deps,
  install: true
)
