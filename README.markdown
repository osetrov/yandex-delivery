# Yandex-delivery

Этот wrapper для старой доставки. [API wrapper для новой Яндекс.доставки](https://github.com/osetrov/yandex-dostavka)

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

### Варианты доставки

#### Поиск вариантов доставки

```ruby
# для Rails senderId указывать не обязательно, в запрос подставится значение из config/yandex_delivery2.yml
body = {
  :to=>{:location=>"Санкт-Петербург"}, 
  :dimensions=>{:length=>1, :height=>1, :width=>1, :weight=>1}
}

YandexDelivery::Request.delivery_options.upsert(body: body)
```

#### Поиск пунктов выдачи заказов

```ruby
YandexDelivery::Request.pickup_points.upsert(body: {locationId: 2})
```

### Операции с заказами

#### Создать черновик заказа

```ruby
response = YandexDelivery::Request.orders.create(body: {deliveryType: 'COURIER'})
order_id = response.body
```

#### Обновить черновик заказа

```ruby
YandexDelivery::Request.orders(order_id).upsert(body: {deliveryType: 'PICKUP'})
```

#### Оформить заказ

```ruby
YandexDelivery::Request.orders.submit.create(body: {orderIds: [order_id]})
```

#### Получить данные о заказе

```ruby
response = YandexDelivery::Request.orders(order_id).retrieve
order = response.body
```

#### Удалить заказ

```ruby
YandexDelivery::Request.orders(order_id).delete
```

#### Получить ярлык заказа

```ruby
YandexDelivery::Request.orders(order_id).label.retrieve
```

#### Поиск заказов

```ruby
sender_ids = YandexDelivery.senders.map{|sender| sender['id']}
YandexDelivery::Request.orders.search.upsert(body: {senderIds: sender_ids, orderIds: [order_id]})
```

#### Получить историю статусов заказа

```ruby
YandexDelivery::Request.orders(order_id).statuses.retrieve
```

#### Получить статус заказов

```ruby
YandexDelivery::Request.orders.status.upsert
```

### Операции с отгрузками

#### Создать заявку на отгрузку

```ruby
body = {
  cabinetId: YandexDelivery.client['id'],
  shipment: {
                type: "WITHDRAW",
                date: "2020-10-05",
                warehouseFrom: YandexDelivery.warehouses.first['id'],
                warehouseTo: 123,
                partnerTo: 678
              },
  intervalId: 765478,
  dimensions: {
                length: 10,
                width: 15,
                height: 40,
                weight: 5.5
               },
  courier: {
                type: "CAR",
                firstName: "Василий",
                middleName: "Иванович",
                lastName: "Пупкин",
                phone: "+79998887766",
                carNumber: "о000оо",
                carBrand: "Maybach"
            },
  comment: "comment"
}
response = YandexDelivery::Request.shipments.application.create(body: body)
shipment_id = response.body['id']
```

#### Подтвердить отгрузку

```ruby
body = {
  cabinetId: YandexDelivery.client['id'],
  shipmentApplicationIds: [shipment_id]
}
YandexDelivery::Request.shipments.application.submit.create(body: body)
```

#### Получить список отгрузок

```ruby
body = {
          cabinetId: YandexDelivery.client['id'],
          shipmentType: "IMPORT",
          dateFrom: "2020-10-05",
          "dateTo": "2020-11-05",
          "partnerIds": 
          [
            239847,
            98234,
            54968
          ]
       }
YandexDelivery::Request.shipments.search.upsert(body: body)
```

#### Получить интервалы самопривозов

```ruby
warehouse_id = YandexDelivery.warehouses.first['id']
YandexDelivery::Request.shipments.intervals.import.retrieve(params: {warehouseId: warehouse_id, date: '2020-10-06'})
```

#### Получить интервалы заборов

```ruby
YandexDelivery::Request.shipments.intervals.withdraw.retrieve(params: {partnerId: 106, date: '2020-10-06'})
```

#### Получить акт передачи заказов

```ruby
YandexDelivery::Request.shipments.applications(shipment_id).act.retrieve(params: {cabinetId: YandexDelivery.client['id']})
```

### Справочные данные

#### Получить полный адрес

```ruby
YandexDelivery::Request.location.retrieve(params: {term: 'Санкт-Петербург'})
```

#### Получить индекс по адресу

```ruby
response = YandexDelivery::Request.location.postal_code.retrieve(params: {address: 'Санкт-Петербург, ул. Профессора Попова, д. 37Щ, БЦ "Сенатор"'})
postal_code = response.body.first[:postalCode]
```

#### Получить список служб доставки

```ruby
YandexDelivery::Request.delivery_services.retrieve(params: {cabinetId: YandexDelivery.client['id']})
```
