require 'spec_helper'

describe ProductPicture do

  it {should respond_to(:name)}
  it {should respond_to(:content_type)}
  it {should respond_to(:image_data)}
  it {should respond_to (:product)}
  describe "picture upload tests" do
    #before {p = ProductPicture.new}
    it {should_not be_valid}
    it "should only allow image as content type" do
    end
  end
end
