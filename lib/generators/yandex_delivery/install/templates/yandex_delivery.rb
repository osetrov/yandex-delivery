require 'yandex-delivery'

YandexDelivery.setup do |config|
  if File.exist?('config/yandex_delivery2.yml')
    template = ERB.new(File.new('config/yandex_delivery2.yml').read)
    processed = YAML.safe_load(template.result(binding))

    config::Request.app_id = processed['YANDEX_DELIVERY_APP_ID']
    config::Request.api_key = processed['YANDEX_DELIVERY_ACCESS_TOKEN']
    config::Request.timeout = 15
    config::Request.open_timeout = 15
    config::Request.symbolize_keys = true
    config::Request.debug = false

    processed['YANDEX_DELIVERY'].each do |k, v|
      config::register k.underscore.to_sym, v
    end
  end
end