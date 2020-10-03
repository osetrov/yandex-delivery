require 'yandex_delivery'

YandexDelivery.setup do |config|
  if File.exist?('config/yandex_delivery.yml')
    template = ERB.new(File.new('config/yandex_delivery2.yml').read)
    processed = YAML.safe_load(template.result(binding))

    config::Request.api_key = processed['YANDEX_DELIVERY_ACCESS_TOKEN']
    config::Request.timeout = 15
    config::Request.open_timeout = 15
    config::Request.symbolize_keys = true
    config::Request.debug = false

    # processed['YANDEX_DELIVERY_API_KEY'].each do |k, v|
    #   config::create_method k.underscore.to_sym
    #   config::register "#{k.underscore}_key".to_sym, v
    # end

    processed['YANDEX_DELIVERY'].each do |k, v|
      config::register k.underscore.to_sym, v
    end
  end
end