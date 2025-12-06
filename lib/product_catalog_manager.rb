module MyApplicationTomiuk
  class ProductCatalogManager # rubocop:disable Style/Documentation
    def initialize(root_dir:, yaml_products_dir:)
      @root_dir = root_dir
      @yaml_products_dir = yaml_products_dir
      @products_root_path = File.join(@yaml_products_dir, 'products')
    end

    def create_products_root
      FileUtils.mkdir_p(@products_root_path)
    end

    def create_category_dirs(categories)
      categories.each do |cat|
        path = File.join(@products_root_path, cat.downcase)
        FileUtils.mkdir_p(path)
      end
    end

    def create_product_file(category:, product:)
      category_path = File.join(@products_root_path, category.downcase)
      FileUtils.mkdir_p(category_path)

      filename = product[:name].downcase.gsub(' ', '_').gsub(/[^\wа-яіїє]/i, '')
      file_path = File.join(category_path, "#{filename}.yaml")

      data = {
        categories: [
          {
            name: category,
            products: [
              {
                name: product[:name],
                price: product[:price],
                description: product[:description],
                media: product[:media]
              }
            ]
          }
        ]
      }

      File.write(file_path, data.to_yaml)
      file_path
    end
  end
end
