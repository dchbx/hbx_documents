require 'spec_helper'

describe HbxDocuments::App.controllers do

  context "basic authentcation in `before` filter" do
    context "without basic auth" do

      it "should reject the request" do
        response = get '/files/new'
        expect(response.status).to be 401
        expect(response.body).to match /HTTP Basic: Access denied.\n/
      end
    end

    context "with basic auth" do
      let(:user) { 'sampleuser' }
      let(:password) { 'secret' }

      it "should authenticate and process the request" do
        allow_any_instance_of(BasicAuth::Authentication).to receive(:user).and_return(user)
        allow_any_instance_of(BasicAuth::Authentication).to receive(:password).and_return(password)

        basic_authorize user, password
        expect((get '/files/new').status).to be 200
      end
    end
  end
end
