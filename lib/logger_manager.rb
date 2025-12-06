# frozen_string_literal: true

require 'logger'
require 'fileutils'

module MyApplicationTomiuk
  class LoggerManager
    class << self
      attr_reader :logger

      def setup(config)
        log_dir = config['logging']['directory']
        log_level = config['logging']['level']
        log_file = config['logging']['files']['application_log']

        FileUtils.mkdir_p(log_dir)

        @logger = Logger.new(File.join(log_dir, log_file))
        @logger.level = Logger.const_get(log_level)
      end

      def log_processed_file(file)
        @logger.info("Processed file: #{file}")
      end

      def log_error(message)
        @logger.error(message)
      end
    end
  end
end
