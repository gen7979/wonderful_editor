# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
require "rails_helper"

RSpec.describe User do
  context "name,email,passwordを指定しているとき" do
    it "アカウントが作られる" do
      user = build(:user)
      expect(user.valid?).to be true
    end
  end

  context "name,email,passwordのいずれかを指定していないとき" do
    it "エラーが返る" do
      user = build(:user, password: nil)
      expect(user.invalid?).to be true
      expect(user.errors.details[:password][0][:error]).to eq :blank
    end
  end

  context "同じ名前のemailが存在しているとき" do
    it "エラーが返る" do
      create(:user, email: "foo@example.com")
      user = build(:user, email: "foo@example.com")
      expect(user.invalid?).to be true
      expect(user.errors.details[:email][0][:error]).to eq :taken
    end
  end
end
