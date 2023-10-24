# -*- encoding: utf-8 -*-
require 'spec_helper'

describe URIParser do
  def self.describe_parsed(url, &block)
    describe ".new('#{url}')" do
      subject { described_class.new(url) }
      module_eval(&block)
    end
  end

  describe '#normalized' do
    it 'is an alias for #uri' do
      uri = URIParser.new('http://foo.com')
      uri.normalized.should == 'http://foo.com/'
    end
  end

  describe_parsed 'http://example.com/foo/bar?a=b&c=d' do
    its(:scheme) { should == 'http' }
    its(:host) { should == 'example.com' }
    its(:path) { should == '/foo/bar' }
    its(:query) { should == 'a=b&c=d' }
    its(:valid?) { should be_truthy }
    its(:uri) { should == 'http://example.com/foo/bar?a=b&c=d' }
    its(:path_and_query) { should == '/foo/bar?a=b&c=d' }
    its(:query_params) { should == { 'a' => 'b', 'c' => 'd' } }
  end

  describe_parsed '@#4ioasfajdkshfas' do
    its(:valid?) { should be_falsy }
  end

  describe_parsed 'http://руцентр.рф/Iñtërnâtiônàlizætiøn!?i18n=true' do
    its(:valid?) { should be_truthy }
    its(:scheme) { should == 'http' }
    its(:host) { should == 'xn--e1aqhcjdv.xn--p1ai' }
    its(:path) { should == '/I%C3%B1t%C3%ABrn%C3%A2ti%C3%B4n%C3%A0liz%C3%A6ti%C3%B8n!' }
    its(:query) { should == 'i18n=true' }
    its(:uri) { should == 'http://xn--e1aqhcjdv.xn--p1ai/I%C3%B1t%C3%ABrn%C3%A2ti%C3%B4n%C3%A0liz%C3%A6ti%C3%B8n!?i18n=true' }
  end

  describe_parsed 'http://subdomain.bar.com' do
    its(:host) { should == 'subdomain.bar.com' }
    its(:path) { should == '/' }
    its(:query) { should == '' }
    its(:path_and_query) { should == '/' }
  end

  describe_parsed 'http://domain.com?a param=a value' do
    its(:uri) { should == 'http://domain.com/?a%20param=a%20value' }
    its(:query_params) { should == { 'a param' => 'a value' } }
  end

  describe_parsed 'http://domain.com?b=&c&d=5' do
    its(:uri) { should == 'http://domain.com/?b=&c&d=5' }
    its(:query_params) { should == { 'b' => nil, 'c' => nil, 'd' => '5' } }
  end

  describe_parsed 'http://domain.com/?&c=3&d=5' do
    its(:uri) { should == 'http://domain.com/?&c=3&d=5' }
    its(:query_params) { should == { nil => nil, 'c' => '3', 'd' => '5' } }
  end

  describe_parsed 'http://domain.com/?c=3&&d=5' do
    its(:uri) { should == 'http://domain.com/?c=3&&d=5' }
    its(:query_params) { should == { 'c' => '3', nil => nil, 'd' => '5' } }
  end

  describe_parsed 'http://domain.com/?c=3&d=5&' do
    its(:uri) { should == 'http://domain.com/?c=3&d=5&' }
    its(:query_params) { should == { 'c' => '3', 'd' => '5' } }
  end
end
