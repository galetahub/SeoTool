module SeoTools
  class Report
    attr_accessor :title, :url, :date, :headers, :links, :ip

    def initialize(title, url, date, headers, links, ip)
      @title = title
      @url = url
      @date = date
      @headers = headers
      @links = links
      @ip = ip
    end

  end
end
