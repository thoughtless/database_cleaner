require 'database_cleaner/generic/base'
require 'active_record'
require 'erb'

module DatabaseCleaner
  module ActiveRecord

    def self.available_strategies
      %w[truncation transaction deletion]
    end

    def self.config_file_location=(path)
      @config_file_location = path
    end

    def self.config_file_location
      @config_file_location ||= "#{DatabaseCleaner.app_root}/config/database.yml"
    end

    module Base
      include ::DatabaseCleaner::Generic::Base

      attr_accessor :connection_hash

      def model=(desired_model)
        @model = desired_model.respond_to?(:constantize) ? desired_model.constantize : desired_model
        @connection_klass = @model
      end

      def model
        @model
      end

      def db=(desired_db)
        @db = desired_db
        load_config
      end

      def db
        @db || super
      end

      def load_config
        if File.file?(ActiveRecord.config_file_location)
          connection_details   = YAML::load(ERB.new(IO.read(ActiveRecord.config_file_location)).result)
          self.connection_hash = connection_details[self.db.to_s]
        end
      end

      def create_connection_klass
        Class.new(::ActiveRecord::Base)
      end

      def connection_klass
        @connection_klass ||= begin
          return ::ActiveRecord::Base if connection_hash.nil?
          klass create_connection_klass
          klass.send :establish_connection, connection_hash
          klass
        end
      end
    end
  end
end
