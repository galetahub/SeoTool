require 'nokogiri'
require 'open-uri'
require 'date'
require 'httparty'
require 'slim'

require_relative 'seo_body'
require_relative 'link'
require_relative 'site_list_item'

module SeoToolApp
  class SeoTool
    attr_accessor :url, :seo_body

#public
    def initialize(params)
      @url ||= params[:url]
      @seo_body = nil
    end

    def analize
      _doc = load_file(@url)
      build_seo_body_from_file(_doc)
      save_to_html
      @seo_body
    end

    def generate_site_list
      path = get_path_to_reports
      extract_reports_list(path)
    end

#private
    #analize
    def load_file(url)
      Nokogiri::HTML(open(url))
    end

    def build_seo_body_from_file(doc)
      _title = get_title(doc)
      _url = @url
      _date = get_date
      _headers = get_headers(@url)
      _links = get_links(doc)
      @seo_body = SeoBody.new(_title, _url, _date, _headers, _links)
    end

    def get_title(doc)
      doc.at_css("head title").text
    end

    def get_date
      DateTime.parse(Time.now.to_s).strftime("%d/%m/%Y %H:%M")
    end

    def get_headers(url)
      HTTParty.get(url)
    end

    def get_links(doc)
      _links_from_file = doc.css("a")
      _links_list = []
      _counter = 1
      _links_from_file.each do |node|
        _link = Link.new(_counter, node.text, node['href'], node['rel'],
          node['target'], node['download'])
        _links_list << _link
        _counter += 1
      end
      _links_list
    end

    def save_to_html
      _env = configure_env_to_render
      _page = create_page(_env)
      save_page(_env.title, _page)
    end

    def configure_env_to_render
      env = Env.new
      env.title = @seo_body.title
      env.seo_body = @seo_body
      env
    end

    def create_page(env)
      _layout = File.read(
        ::File.expand_path('../../../views/layout.slim',  __FILE__))
      _contents = File.read(
        ::File.expand_path('../../../views/report_template.slim',  __FILE__))
      _l = Slim::Template.new { _layout }
      _c = Slim::Template.new { _contents }.render(env)
      _page = _l.render{ _c }
    end

    def save_page(name, page)
      path = File.expand_path('../../../public/reports', __FILE__)
      path << "/" + name + ".html"
      File.open(path, 'w') { |file| file.write(page) }
    end

    class Env
      attr_accessor :title, :seo_body
    end

    #generate_site_list
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
      File.expand_path('../../../public/reports', __FILE__)
    end

    private :load_file, :build_seo_body_from_file, :get_title, :get_date,
      :get_headers, :get_links, :save_to_html, :configure_env_to_render,
      :create_page, :save_page
    private :extract_reports_list, :get_site_list_item, :get_path_to_reports

  end
end
