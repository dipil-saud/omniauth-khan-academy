require 'spec_helper'

describe OmniAuth::Strategies::KhanAcademy do
  let(:consumer_token){ "dummy_consumer_token" }
  let(:consumer_secret){ "dummy_consumer_secret" }

  let(:khan_academy){ OmniAuth::Strategies::KhanAcademy.new({}, consumer_secret, consumer_token) }
  subject{ khan_academy }


  describe "DEFAULT_CLIENT_OPTIONS" do
    subject{ OmniAuth::Strategies::KhanAcademy::DEFAULT_CLIENT_OPTIONS }

    it{ should eq({"http_method" => :get, "site" => "http://www.khanacademy.org", "request_token_path" => "/api/auth/request_token", "access_token_path" => "/api/auth/access_token"}) }
  end

  describe "#client_options" do
    context "when the option client_options are not specified" do
      it "should equal the default_client_options" do
        subject.client_options.should eq(OmniAuth::Strategies::KhanAcademy::DEFAULT_CLIENT_OPTIONS)
      end
    end

    context "when the option client_options are specified" do
      let(:custom_client_options){ {"http_method" => :post} }

      subject{ OmniAuth::Strategies::KhanAcademy.new({}, consumer_secret, consumer_token, client_options: custom_client_options) }

      it "should equal the default_client_options merged with the custom options" do
        subject.client_options.should eq(OmniAuth::Strategies::KhanAcademy::DEFAULT_CLIENT_OPTIONS.merge(custom_client_options))
      end
    end
  end

  describe "#request_phase" do
    before do
      khan_academy.stub(:login_url).and_return('login_url')
      khan_academy.stub(:session).and_return({})
    end

    it "should redirect to the login url at khan_academy" do
      khan_academy.should_receive(:redirect).with('login_url').once

      khan_academy.request_phase
    end
  end

  describe "login_url" do
    before do
      khan_academy.stub(:callback_url).and_return("http://callback.url")
    end

    subject { khan_academy.login_url }

    it{ should be_a(String) }
    it{ should =~ /\Ahttp:\/\/www.khanacademy.org\/api\/auth\/request_token\?oauth_callback=.+&oauth_consumer_key=\w+&oauth_nonce=\w+&oauth_signature.+&oauth_signature_method=HMAC-SHA1&oauth_timestamp=\d+&oauth_version=1\.0\z/ }
  end
end