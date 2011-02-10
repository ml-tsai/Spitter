require 'spec_helper'

describe "FriendlyForwardings" do
  describe "GET friendly_forwardings" do
    it "should redirect to intended path" do
      user = Factory(:user)
      visit edit_user_path(user)
      fill_in :email, :with => user.email
      fill_in :password, :with => user.password
      click_button
      response.should render_template('users/edit')
    end
  end
end
