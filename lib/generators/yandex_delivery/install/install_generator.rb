# frozen_string_literal: true
#
module YandexDelivery
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def generate_install
      copy_file 'yandex_delivery.yml', 'config/yandex_delivery2.yml'
      copy_file 'yandex_delivery.rb', 'config/initializers/yandex_delivery2.rb'
    end
  end
end

