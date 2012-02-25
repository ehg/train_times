require File.dirname(__FILE__) + '/helper'
require File.dirname(__FILE__) + '/../google_oauth.rb'

WebMock.allow_net_connect!

describe GoogleOAuth do
  use_vcr_cassette 'requests'

  context "When obtaining a User Code" do
    before do
      @response = GoogleOAuth.authorise
    end

    it "should post to the OAuth 2.0 device endpoint" do
      a_request(:post, "https://accounts.google.com/o/oauth2/device/code").should have_been_made
    end

    it "should post the client id" do
      a_request(:post, "https://accounts.google.com/o/oauth2/device/code")
      .with { |req| req.body =~ /client_id=344903981192.apps.googleusercontent.com/}
      .should have_been_made
    end

    it "should post the scopes" do
      a_request(:post, "https://accounts.google.com/o/oauth2/device/code")
      .with { |req| req.body =~ /scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Flatitude.current.best/}
      .should have_been_made
    end


    context "if successful" do
      it "should receive a device code" do
        @response['device_code'].should_not be_nil
      end

      it "should receive a user code" do
        @response['user_code'].should_not be_nil
      end

      it "should receive a verification url" do
        @response['verification_url'].should_not be_nil
      end

      it "should receive an 'expires in' value" do
        @response['expires_in'].should_not be_nil
      end

      it "should receive an interval value" do
        @response['interval'].should_not be_nil
      end
    end

    context "if it fails" do
      xit "should raise an authentication failure exception"
    end
  end

  context "when we have a device code" do
    before do
      @device_code = '4/ljGGIAyYdrXEqrSwdhGhkot2_Teo'
      @tokens = GoogleOAuth.get_tokens(@device_code)
    end

    it "should get an access token" do
      @tokens.should_not be_nil
      @tokens['access_token'].should_not be_nil
    end

    it "should get a refresh token" do
      @tokens.should_not be_nil
      @tokens['refresh_token'].should_not be_nil
    end

    context "when we need to refresh our token" do
      before do
        @tokens = GoogleOAuth.get_tokens(@device_code, refresh=true)
      end
      it "should get an access token" do
        @tokens.should_not be_nil
        @tokens['access_token'].should_not be_nil
      end

      it "should get a refresh token" do
        @tokens.should_not be_nil
        @tokens['refresh_token'].should_not be_nil
      end
    end
  end

end
