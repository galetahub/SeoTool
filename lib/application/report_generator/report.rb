module SeoTools
  class Report
    attr_accessor :title, :url, :date, :headers, :links, :ip

    def initialize
      @title = nil
      @url = nil
      @date = nil
      @headers = nil
      @links = nil
      @ip = nil
    end

    def is_a(type)
      if self.class == type
        true
      else
        false
      end
    end

  end
end
