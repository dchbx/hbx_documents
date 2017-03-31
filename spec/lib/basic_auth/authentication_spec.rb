require 'spec_helper'

describe BasicAuth::Authentication do

  class DummyClass
    include BasicAuth::Authentication
  end

  let(:subject) { DummyClass.new }

  describe "authenticate_with_http_basic" do
    before do
      request = OpenStruct.new
      request.env = {}
      request.env['HTTP_AUTHORIZATION'] = "Basic c2FtcGxlOnNhbXBsZQ=="
      allow(subject).to receive(:request).and_return(request)
    end

    context "valid username:password" do
      it "should return true" do
        allow(subject).to receive(:user).and_return("sample")
        allow(subject).to receive(:password).and_return("sample")
        expect(subject.authenticate_with_http_basic).to be_truthy
      end
    end

    context "invalid username:password" do
      it "should return false" do
        allow(subject).to receive(:user).and_return("sample2")
        allow(subject).to receive(:password).and_return("sample2")
        expect(subject.authenticate_with_http_basic).to be_falsey
      end
    end
  end

  describe "request_http_basic_authentication" do
    let(:response) { OpenStruct.new }

    before do
      response.headers = {}
      response.body = ""
      allow(subject).to receive(:response).and_return(response)
    end

    it "should return false and set response headers" do
      expect(subject.request_http_basic_authentication).to be_falsey
      expect(response.headers["WWW-Authenticate"]).to eql(%(Basic realm="Application"))
      expect(response.body).to eql("HTTP Basic: Access denied.\n")
    end
  end
end
