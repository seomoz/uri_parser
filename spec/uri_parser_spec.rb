# -*- encoding: utf-8 -*-
require 'spec_helper'

describe URIParser do
  def self.describe_parsed(url, &block)
    describe "URIParser.new('#{url}')" do
      subject { described_class.new(url) }
      module_eval(&block)
    end
  end

  describe_parsed 'http://example.com/foo/bar?a=b&c=d' do
    its(:scheme) { should == 'http' }
    its(:host) { should == 'example.com' }
    its(:path) { should == '/foo/bar' }
    its(:query) { should == 'a=b&c=d' }
    its(:valid?) { should be_true }
    its(:uri) { should == 'http://example.com/foo/bar?a=b&c=d' }
  end

  describe_parsed '@#4ioasfajdkshfas' do
    its(:valid?) { should be_false }
  end

  describe_parsed 'http://руцентр.рф/Iñtërnâtiônàlizætiøn!?i18n=true' do
    its(:valid?) { should be_true }
    its(:scheme) { should == 'http' }
    its(:host) { should == 'xn--e1aqhcjdv.xn--p1ai' }
    its(:path) { should == '/I%C3%B1t%C3%ABrn%C3%A2ti%C3%B4n%C3%A0liz%C3%A6ti%C3%B8n!' }
    its(:query) { should == 'i18n=true' }
    its(:uri) { should == 'http://xn--e1aqhcjdv.xn--p1ai/I%C3%B1t%C3%ABrn%C3%A2ti%C3%B4n%C3%A0liz%C3%A6ti%C3%B8n!?i18n=true' }
  end

  describe_parsed 'http://subdomain.bar.com' do
    its(:host) { should == 'subdomain.bar.com' }
    its(:path) { should == '/' }
  end
end
