require 'nokogiri'
require 'open-uri'
require 'date'
require 'httparty'
require 'slim'
require 'public_suffix'

require_relative 'report'
require_relative 'link'

require ::File.expand_path('../../storage/storage_provider', __FILE__)

module SeoTools
  class ReportGenerator
    include Storage

    attr_accessor :url, :report

#public
    def initialize(params)
      @url ||= params[:url]
      @report = nil
    end

    def generate
      @report = fetch_report
      save_report(@report)
      @report
    end

#private
    def extract_page_from(url)
      Nokogiri::HTML(open(url))
    end

    def fetch_report
      _doc = extract_page_from(@url)
      _title = get_title(_doc)
      _url = @url
      _date = get_date
      _headers = get_headers(@url)
      _links = get_links(_doc)
      _ip = get_ip(@url)

      @report = Report.new(_title, _url, _date, _headers, _links, _ip)
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

    def get_ip(url)
      uri = URI.parse(url)
      domain = PublicSuffix.parse(uri.host)
      Resolv.getaddress(domain.to_s)
    end

    def save_report(report)
      sp = StorageProvider.new
      sp.add(report)
    end

    private :extract_page_from, :fetch_report, :get_title, :get_date,
    :get_headers, :get_links, :get_ip, :save_report

  end
end
