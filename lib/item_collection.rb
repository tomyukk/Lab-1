require_relative 'item_container'
require 'json'
require 'csv'
require 'yaml'

module MyApplicationTomiuk
  class ItemCollection
    include MyApplicationTomiuk::ItemContainer
    include Enumerable

    attr_accessor :items

    def initialize
      @items = []
      self.class.increment_object_count
      LoggerManager.log_processed_file('New ItemCollection created')
    end

    def each(&)
      items.each(&)
    end

    def save_to_file(path)
      File.write(path, items.map(&:to_s).join("\n"))
      LoggerManager.log_processed_file("Saved to file: #{path}")
    end

    def save_to_json(path)
      File.write(path, JSON.pretty_generate(items.map(&:to_h)))
      LoggerManager.log_processed_file("Saved to JSON: #{path}")
    end

    def save_to_csv(path)
      CSV.open(path, 'w') do |csv|
        csv << items.first.to_h.keys
        items.each { |item| csv << item.to_h.values }
      end
      LoggerManager.log_processed_file("Saved to CSV: #{path}")
    end

    def save_to_yml(directory)
      Dir.mkdir(directory) unless Dir.exist?(directory)
      items.each_with_index do |item, i|
        File.write("#{directory}/item_#{i + 1}.yml", item.to_h.to_yaml)
      end
      LoggerManager.log_processed_file("Saved to YAML: #{directory}")
    end

    def generate_test_items(count)
      count.times do
        add_item(MyApplicationTomiuk::Item.generate_fake)
      end
    end
  end
end
