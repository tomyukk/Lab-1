require 'mechanize'
require 'open-uri'

module MyApplicationTomiuk
  class SimpleWebsiteParser
    attr_reader :config, :agent, :item_collection

    def initialize(config)
      @config = config['web_scraping']
      @agent = Mechanize.new
      @item_collection = MyApplicationTomiuk::ItemCollection.new

      LoggerManager.log_processed_file('SimpleWebsiteParser initialized')
    end

    def start_parse
      url = config['start_page']

      unless check_url_response(url)
        LoggerManager.log_error("Start page not available: #{url}")
        return
      end

      LoggerManager.log_processed_file("Start parsing page: #{url}")

      page = agent.get(url)
      product_links = extract_products_links(page)

      LoggerManager.log_processed_file("Found #{product_links.size} product links")

      threads = []
      mutex = Mutex.new

      product_links.each do |link|
        threads << Thread.new do
          product = parse_product_page(link)
          next unless product

          mutex.synchronize do
            item_collection.add_item(product)
          end
        rescue StandardError => e
          LoggerManager.log_error("Thread error: #{e.message}")
        end
      end

      threads.each(&:join)

      LoggerManager.log_processed_file("Parsing finished. Items collected: #{item_collection.items.size}")
      item_collection
    end

    def extract_products_links(page)
      selector = config['product_name_selector']
      links = page.search(selector).map { |e| e['href'] }.compact

      LoggerManager.log_processed_file("Extracted #{links.size} links with selector #{selector}")

      links
    end

    def parse_product_page(link)
      unless check_url_response(link)
        LoggerManager.log_error("Product page not available: #{link}")
        return nil
      end

      LoggerManager.log_processed_file("Parsing product page: #{link}")

      page = agent.get(link)

      item = MyApplicationTomiuk::Item.new(
        name: extract_product_name(page),
        price: extract_product_price(page),
        description: extract_product_description(page),
        category: 'parsed',
        image_path: extract_product_image(page)
      )

      download_image(item.image_path, 'parsed')

      item
    rescue StandardError => e
      LoggerManager.log_error("parse_product_page error: #{e.message}")
      nil
    end

    def extract_product_name(page)
      selector = config['product_name_selector']
      page.at(selector)&.text&.strip || 'Unknown name'
    end

    def extract_product_price(page)
      selector = config['product_price_selector']
      price = page.at(selector)&.text&.gsub(/[^\d.]/, '')

      (price || 0).to_f
    end

    def extract_product_description(page)
      selector = config['product_description_selector']
      page.at(selector)&.text&.strip || 'No description'
    end

    def extract_product_image(page)
      selector = config['product_image_selector']
      img = page.at(selector)

      img ? img['href'] || img['src'] : nil
    end

    def check_url_response(url)
      agent.head(url)
      true
    rescue StandardError
      false
    end

    def download_image(url, category)
      return if url.nil?

      dir = File.join('media', category)
      Dir.mkdir('media') unless Dir.exist?('media')
      Dir.mkdir(dir) unless Dir.exist?(dir)

      file_path = File.join(dir, File.basename(url))

      URI.open(url) do |img|
        File.write(file_path, img.read)
      end

      LoggerManager.log_processed_file("Saved image: #{file_path}")
    rescue StandardError => e
      LoggerManager.log_error("image download failed: #{e.message}")
    end
  end
end
