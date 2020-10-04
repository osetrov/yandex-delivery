# Yandex-delivery

API wrapper для Яндекс.доставки [API](https://yandex.ru/dev/delivery-3/doc/dg/).

## Установка Ruby

    $ gem install yandex-delivery

## Установка Rails

добавьте в Gemfile:

    gem 'yandex-delivery'

и запустите `bundle install`.

Затем:

    rails g yandex_delivery:install

## Требования

Необходимо получить [токен авторизации](https://yandex.ru/dev/delivery-3/doc/dg/concepts/access.html).

## Использование Rails

В файл `config/yandex_delivery2.yml` вставьте ваши данные из настоек яндекс доставки и токен авторизации

## Использование Ruby

Сначала создайте экземпляр объекта `YandexDelivery::Request`:

```ruby
delivery = YandexDelivery::Request.new(api_key: "your_access_token")
```

Вы можете изменять `api_key`, `timeout`, `open_timeout`, `faraday_adapter`, `proxy`, `symbolize_keys`, `logger`, и `debug`:

```ruby
YandexDelivery::Request.api_key = "your_access_token"
YandexDelivery::Request.timeout = 15
YandexDelivery::Request.open_timeout = 15
YandexDelivery::Request.symbolize_keys = true
YandexDelivery::Request.debug = false
```

Либо в файле `config/initializers/yandex_delivery2.rb` для Rails.

## Debug Logging

Pass `debug: true` to enable debug logging to STDOUT.

```ruby
delivery = YandexDelivery::Request.new(api_key: "your_access_token", debug: true)
```

### Custom logger

Ruby `Logger.new` is used by default, but it can be overrided using:

```ruby
delivery = YandexDelivery::Request.new(api_key: "your_access_token", debug: true, logger: MyLogger.new)
```

Logger can be also set by globally:

```ruby
YandexDelivery::Request.logger = MyLogger.new
```

## Примеры

### Поиск вариантов доставки

```ruby
# для Rails senderId указывать не обязательно, в запрос подставится значение из config/yandex_delivery2.yml
body = {
  :to=>{:location=>"Санкт-Петербург"}, 
  :dimensions=>{:length=>1, :height=>1, :width=>1, :weight=>1}
}

YandexDelivery::Request.delivery_options.upsert(body: body)
```