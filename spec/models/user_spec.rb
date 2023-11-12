require "rails_helper"

RSpec.describe User do
  context "name,email,passwordを指定しているとき" do
    it "アカウントが作られる" do
      user =  build(:user)
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
    fit "エラーが返る" do
      create(:user, email: "foo@example.com")
      user = build(:user, email: "foo@example.com")
      expect(user.invalid?).to be true
      expect(user.errors.details[:email][0][:error]).to eq :taken
    end
  end
end
