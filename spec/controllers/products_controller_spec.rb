require 'spec_helper'

describe ProductsController do

  describe "GET 'new'" do

    describe 'Before Sign in' do
      it "redirects to sign in page" do
        get 'new'
        response.should be_redirect
      end
    end
  end

end
