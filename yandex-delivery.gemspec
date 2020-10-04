Gem::Specification.new do |s|
  s.name        = 'yandex-delivery'
  s.version     = '0.0.4'
  s.date        = '2020-08-11'
  s.summary     = "Yandex delivery"
  s.description = ""
  s.authors     = ["Pavel Osetrov"]
  s.email       = 'pavel.osetrov@me.com'
  s.files = Dir['lib/**/*', 'LICENSE', 'README.markdown']

  s.homepage    = 'https://github.com/osetrov/yandex-delivery'
  s.license       = 'MIT'

  s.add_dependency('faraday', '>= 0.16.0')
  s.add_dependency('multi_json', '>= 1.11.0')

  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 2.3.8'
end
