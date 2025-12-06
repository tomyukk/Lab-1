module MyApplicationTomiuk
  class Item
    include Comparable

    attr_accessor :name, :price, :description, :category, :image_path

    # --- Конструктор ---
    def initialize(params = {})
      @name        = params.fetch(:name, 'Default name')
      @price       = params.fetch(:price, 0)
      @description = params.fetch(:description, 'No description')
      @category    = params.fetch(:category, 'General')
      @image_path  = params.fetch(:image_path, 'images/default.png')

      LoggerManager.log_processed_file("Item initialized with name=#{@name}")

      yield self if block_given?
    rescue StandardError => e
      LoggerManager.log_error("Error in Item initialize: #{e.message}")
    end

    def <=>(other)
      price <=> other.price
    end

    def update
      yield self if block_given?
    rescue StandardError => e
      LoggerManager.log_error("Update error: #{e.message}")
    end

    def to_s
      attrs = instance_variables.map do |var|
        "#{var}=#{instance_variable_get(var)}"
      end.join(', ')

      "Item(#{attrs})"
    end

    def to_h
      instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete('@').to_sym] = instance_variable_get(var)
      end
    end

    def inspect
      "#<Item name='#{name}', price=#{price}, category='#{category}'>"
    end

    alias info to_s

    def self.generate_fake
      new(
        name: Faker::Commerce.product_name,
        price: Faker::Commerce.price(range: 10.0..100.0).round(2),
        description: Faker::Lorem.sentence,
        category: Faker::Commerce.department,
        image_path: "images/#{Faker::Lorem.word}.png"
      )
    rescue StandardError => e
      LoggerManager.log_error("Fake generation error: #{e.message}")
      nil
    end
  end
end
