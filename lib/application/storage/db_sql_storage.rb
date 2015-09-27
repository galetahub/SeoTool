require 'pg'

require_relative 'base_storage'
require_relative 'site_list_item'
require ::File.expand_path('../../report_generator/report', __FILE__)
require ::File.expand_path('../../report_generator/link', __FILE__)


module Storage
  class DbSqlStorage < BaseStorage
    include SeoTools

    attr_accessor :config
    def initialize
      path_to_config_file = File.expand_path(
        '../../../../config/database.yml', __FILE__)
      @config = YAML.load_file(path_to_config_file)
    end

    def add(report)
      begin
        con = PG.connect :dbname => @config['db_name'],
          :user => @config['username'],
          :password => @config['password']

        params = [report.url, report.title, report.ip, report.date]
        con.exec_params("INSERT INTO reports (url, title, ip, created_at)
          VALUES($1, $2, $3, $4)", params)

        report.headers.each do |key, value|
          params = [report.url, key, value]
          con.exec_params("INSERT INTO headers
            (url, key, value) VALUES($1, $2, $3)", params)
        end

        counter = 1
        report.links.each do |link|
          params = [counter, report.url, link.title, link.href, link.rel,
            link.target, link.download]
          con.exec_params("INSERT INTO links
            (number, url, title, href, rel, target, download)
            VALUES($1, $2, $3, $4, $5, $6, $7)", params)
          counter += 1
        end

      rescue PG::Error => e
        puts e.message
      ensure
        con.close if con
      end
    end

    def find(id)
      report = Report.new
      begin
        con = PG.connect :dbname => @config['db_name'],
          :user => @config['username'],
          :password => @config['password']

        params = [id]
        result = con.exec_params("SELECT * FROM reports WHERE id = $1", params)

        report.url = result.getvalue(0, 1)
        report.title = result.getvalue(0, 2)
        report.ip = result.getvalue(0, 3)
        report.date = result.getvalue(0, 4)

        params = [report.url]
        result = con.exec_params("SELECT * FROM headers
          WHERE url = $1", params)

        hash = Hash.new
        result.each do |row|
          key = row['key']
          value = row['value']
          hash[key] = value
        end
        report.headers = hash

        result = con.exec_params("SELECT * FROM links
          WHERE url = $1", params)

        list = Array.new
        result.each do |row|
          link = Link.new(row['number'], row['title'], row['href'], row['rel'],
          row['target'], row['download'])
          list << link
        end

        report.links = list

        report
      rescue PG::Error => e
        puts e.message
      ensure
        con.close if con
      end
      report
    end

    def all
      begin
        con = PG.connect :dbname => @config['db_name'],
          :user => @config['username'],
          :password => @config['password']

        list = Array.new
        result = con.exec("SELECT * FROM reports")
        result.each do |row|
          list << SiteListItem.new(row['url'], row['created_at'],
            "/report/" + row['id'])
        end
        list
      rescue PG::Error => e
        puts e.message
      ensure
        con.close if con
      end
    end

  end
end
