require_relative 'base_storage'
require_relative 'site_list_item'

module Storage
  class FileStorage < BaseStorage
# public
    def add(report)
      _env = configure_env_to_render(report)
      _page = create_page(_env)
      save_page(_env.title, _page)
    end

    def find(filename)
      path = File.expand_path('../../../../public/reports', __FILE__)
      page = path + '/' + filename.to_s
    end

    def all
      path = get_path_to_reports
      extract_reports_list(path)
    end

#private
    #add

    def configure_env_to_render(report)
      env = Env.new
      env.title = report.title
      env.report = report
      env
    end

    def create_page(env)
      _layout = File.read(
        ::File.expand_path('../../../../views/layout.slim',  __FILE__))
      _contents = File.read(
        ::File.expand_path('../../../../views/report_template.slim',  __FILE__))
      _l = Slim::Template.new { _layout }
      _c = Slim::Template.new { _contents }.render(env)
      _page = _l.render{ _c }
    end

    def save_page(name, page)
      path = File.expand_path('../../../../public/reports', __FILE__)
      path << "/" + name + ".html"
      File.open(path, 'w') { |file| file.write(page) }
    end

    class Env
      attr_accessor :title, :report
    end

    private :configure_env_to_render, :create_page,
      :save_page

    #all
    def extract_reports_list(path)
      list = []
      Dir.foreach(path) do |item|
        #cheking files not to be folders
        next if item == '.' or item == '..'
        list << get_site_list_item(path, item)
      end
      list
    end

    def get_site_list_item(path, item)
      lines = File.read(path + '/' + item)
      doc = Nokogiri::HTML(lines)
      link = doc.at_css("h2").text
      date = doc.at_css("h3").text
      relative_link =  'report/' + item
      SiteListItem.new(link, date, relative_link)
    end

    def get_path_to_reports
      File.expand_path('../../../../public/reports', __FILE__)
    end

    private :extract_reports_list, :get_site_list_item,
      :get_path_to_reports


  end
end
