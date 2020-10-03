require 'yandex-delivery/yandex_delivery_error'
require 'yandex-delivery/yandex_error'
require 'yandex-delivery/request'
require 'yandex-delivery/api_request'
require 'yandex-delivery/response'

module YandexDelivery
  class << self
    def setup
      yield self
    end
  end
end
