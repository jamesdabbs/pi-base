require 'spec_helper'

describe "Spaces" do
  describe "GET /spaces" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get spaces_path
      response.status.should be(200)
    end

    pending "write request specs"
  end
end
