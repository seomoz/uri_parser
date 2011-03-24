require 'spec_helper'

describe URIParser do
  def self.described_parsed(url, &block)
    describe "URIParser.new('#{url}')" do
      subject { described_class.new(url) }
      module_eval(&block)
    end
  end

  described_parsed 'http://example.com/foo/bar?a=b&c=d' do
    its(:scheme) { should == 'http' }
    its(:host) { should == 'example.com' }
    its(:port) { should == '' }
    its(:path) { should == '/foo/bar' }
    its(:query) { should == 'a=b&c=d' }
    its(:valid?) { should be_true }
  end
end
