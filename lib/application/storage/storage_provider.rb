require_relative 'file_storage'
require_relative 'db_sql_storage'
require_relative 'db_orm_storage'

module Storage
  class StorageProvider
    attr_accessor :storage, :config

    def initialize()
      path_to_config_file = File.expand_path(
        '../../../../config/config.yml', __FILE__)
      @config = YAML.load_file(path_to_config_file)

      if @config['storage'] == "file"
        @storage = FileStorage.new
      elsif @config['storage'] == "db_sql"
        @storage = DbSqlStorage.new
      elsif @config['storage'] == "db_orm"
        @storage = DbOrmStorage.new
      end

    end

    def add(report)
      @storage.add(report)
    end

    def find(id)
      @storage.find(id)
    end

    def all
      @storage.all
    end

  end
end
