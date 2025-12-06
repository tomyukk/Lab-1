# frozen_string_literal: true

require 'debug'

require_relative 'lib/app_config_loader'

MyApplicationTomiuk::AppConfigLoader.load_libs('lib')

config = MyApplicationTomiuk::AppConfigLoader.config(
  'config/default_config.yaml',
  'config'
)

MyApplicationTomiuk::AppConfigLoader.pretty_print_config_data

MyApplicationTomiuk::LoggerManager.setup(config)
MyApplicationTomiuk::LoggerManager.log_processed_file('main.rb')

# pcm = MyApplicationTomiuk::ProductCatalogManager.new(
#   root_dir: Dir.pwd,
#   yaml_products_dir: 'config/yaml_config'
# )

# pcm.create_products_root
# pcm.create_category_dirs(%w[Вітаміни Мінерали])

# pcm.create_product_file(
#   category: 'Вітаміни',
#   product: {
#     name: 'Nutrilite Вітамін D',
#     price: 450,
#     description: 'Приклад опису',
#     media: 'products/вітаміни/nutrilite_вітамін_d.jpeg'
#   }
# )

# cart = MyApplicationTomiuk::ItemCollection.new

# cart.generate_test_items(3)
# cart.show_all_items

# cart.save_to_json('output/items.json')
# cart.save_to_csv('output/items.csv')
# cart.save_to_yml('output/yml_items')

# configurator = MyApplicationTomiuk::Configurator.new

# configurator.configure(
#   run_website_parser: 1,
#   run_save_to_csv: 1,
#   run_save_to_yaml: 1,
#   run_save_to_sqlite: 1
# )

# configurator.print_config

# puts 'Доступні конфігураційні ключі:'
# puts MyApplicationTomiuk::Configurator.available_methods

parser = MyApplicationTomiuk::SimpleWebsiteParser.new(config)

puts 'Парсер успішно ініціалізовано!'


# ============================================================
# 2. ЗАПУСК ПАРСИНГУ САЙТУ
# ============================================================

parsed_items = parser.start_parse

puts 'Парсинг завершено!'
puts "Зібрано елементів: #{parsed_items.items.size}"


# ============================================================
# 3. ЗБЕРЕЖЕННЯ РЕЗУЛЬТАТІВ
# ============================================================

parsed_items.save_to_json('output/parsed_items.json')
parsed_items.save_to_csv('output/parsed_items.csv')
parsed_items.save_to_yml('output/parsed_items')

puts 'Результати збережено у форматах JSON, CSV та YAML.'

# config = YAML.load_file('default_config.yaml')

# connector = MyApplicationTomiuk::DatabaseConnector.new(config)
# connector.connect_to_database

# puts connector.db.inspect

# connector.close_connection

puts 'Успішно завершено!'
