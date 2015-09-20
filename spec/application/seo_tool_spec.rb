require 'spec_helper'
require 'seo_tool'
include SeoToolApp

describe SeoTool do
  subject do
    params = { :url => "https://vk.com" }
    SeoTool.new(params)
  end

  describe "SeoTool#analize" do
    it "returns SeoBody" do
        seo_body = subject.analize
        expect(seo_body).to be_a(SeoBody)
    end
  end

  describe "SeoTool#generate_site_list" do
    it "returns saved reports list" do
        list = subject.generate_site_list
        expect(list).to be_an(Array)
    end
  end

end
