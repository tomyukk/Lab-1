module MyApplicationTomiuk
  class Configurator
    attr_reader :config

    DEFAULT_CONFIG = {
      run_website_parser: 0,
      run_save_to_csv: 0,
      run_save_to_json: 0,
      run_save_to_yaml: 0,
      run_save_to_sqlite: 0,
      run_save_to_mongodb: 0
    }.freeze

    def initialize
      @config = DEFAULT_CONFIG.dup
      puts '[Configurator] Конфігурація ініціалізована.'
    end

    def configure(overrides = {})
      overrides.each do |key, value|
        if @config.key?(key)
          @config[key] = value
          puts "[Configurator] Встановлено #{key} = #{value}"
        else
          warn "[Configurator WARNING] Невідомий параметр: #{key}"
        end
      end
    end

    def self.available_methods
      DEFAULT_CONFIG.keys
    end

    def print_config
      puts "\n=== Поточна конфігурація ==="
      @config.each { |k, v| puts "#{k}: #{v}" }
      puts "============================\n\n"
    end
  end
end
