require 'spec_helper'

describe URIParser do
  url = 'http://example.com/foo/bar?a=b&c=d'

  describe "URIParser.new('#{url}')" do
    subject { described_class.new(url) }
    its(:host) { should == 'example.com' }
  end
end
