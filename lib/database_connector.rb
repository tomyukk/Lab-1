require 'sqlite3'
require 'mongo'

module MyApplicationTomiuk
  class DatabaseConnector
    attr_reader :db

    def initialize(config)
      @config = config
      @db = nil
      LoggerManager.log_processed_file('DatabaseConnector initialized')
    end

    def connect_to_database
      type = @config['database']['type']

      LoggerManager.log_processed_file("Connecting to database: #{type}")

      case type
      when 'sqlite'
        connect_to_sqlite
      when 'mongodb'
        connect_to_mongodb
      else
        LoggerManager.log_error("Unsupported database type: #{type}")
        raise "Unsupported database type: #{type}"
      end
    end

    def close_connection
      return unless @db

      if @db.is_a?(SQLite3::Database)
        @db.close
        LoggerManager.log_processed_file('SQLite connection closed')
      elsif @db.is_a?(Mongo::Client)
        @db.close
        LoggerManager.log_processed_file('MongoDB connection closed')
      end

      @db = nil
    end

    private

    def connect_to_sqlite
      db_path = @config['database']['sqlite']['path']

      begin
        @db = SQLite3::Database.new(db_path)
        LoggerManager.log_processed_file("Connected to SQLite at #{db_path}")
      rescue StandardError => e
        LoggerManager.log_error("SQLite connection error: #{e.message}")
        raise "SQLite connection failed: #{e.message}"
      end
    end

    def connect_to_mongodb
      uri = @config['database']['mongodb']['uri']
      db_name = @config['database']['mongodb']['db_name']

      begin
        client = Mongo::Client.new(uri, database: db_name)
        @db = client

        LoggerManager.log_processed_file("Connected to MongoDB: #{uri}/#{db_name}")
      rescue StandardError => e
        LoggerManager.log_error("MongoDB connection error: #{e.message}")
        raise "MongoDB connection failed: #{e.message}"
      end
    end
  end
end
