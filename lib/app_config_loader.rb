# frozen_string_literal: true

require 'yaml'
require 'erb'
require 'json'

module MyApplicationTomiuk
  class AppConfigLoader
    class << self
      attr_reader :config_data, :loaded_libs

      def config(default_config_path, additional_dir, &block)
        @config_data = {}

        load_default_config(default_config_path)
        load_config(additional_dir)

        block.call(@config_data) if block_given?

        @config_data
      end

      def pretty_print_config_data
        puts JSON.pretty_generate(@config_data)
      end

      def load_libs(lib_dir)
        @loaded_libs ||= []

        system_libs = %w[date fileutils json yaml logger erb]

        system_libs.each do |lib|
          require lib
        end

        Dir.glob("#{lib_dir}/**/*.rb").each do |file|
          next if @loaded_libs.include?(file)

          require_relative "../#{file}"
          @loaded_libs << file
        end
      end

      private

      def load_default_config(path)
        erb = ERB.new(File.read(path))
        yaml = YAML.safe_load(erb.result, aliases: true)
        @config_data.merge!(yaml)
      end

      def load_config(dir)
        Dir.glob("#{dir}/**/*.yaml").each do |file|
          yaml = YAML.load_file(file)
          @config_data.merge!(yaml)
        end
      end
    end
  end
end
