# frozen_string_literal: true

require_relative 'lib/app_config_loader'

MyApplicationTomiuk::AppConfigLoader.load_libs('lib')

config = MyApplicationTomiuk::AppConfigLoader.config(
  'config/default_config.yaml',
  'config'
)

MyApplicationTomiuk::AppConfigLoader.pretty_print_config_data

MyApplicationTomiuk::LoggerManager.setup(config)
MyApplicationTomiuk::LoggerManager.log_processed_file('main.rb')

pcm = MyApplicationTomiuk::ProductCatalogManager.new(
  root_dir: Dir.pwd,
  yaml_products_dir: 'config/yaml_config'
)

pcm.create_products_root
pcm.create_category_dirs(%w[Вітаміни Мінерали])

pcm.create_product_file(
  category: 'Вітаміни',
  product: {
    name: 'Nutrilite Вітамін D',
    price: 450,
    description: 'Приклад опису',
    media: 'products/вітаміни/nutrilite_вітамін_d.jpeg'
  }
)

# cart = MyApplicationTomiuk::ItemCollection.new

# cart.generate_test_items(3)
# cart.show_all_items

# cart.save_to_json('output/items.json')
# cart.save_to_csv('output/items.csv')
# cart.save_to_yml('output/yml_items')

puts 'Успішно завершено!'
