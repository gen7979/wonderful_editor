require "rails_helper"

RSpec.describe User do
  context "name,email,passwordを指定しているとき" do
    it "アカウントが作られる" do
      user = User.new(name: "foo", email: "foo@example.com", password: "abc123")
      expect(user.valid?).to be true
    end
  end

  context "name,email,passwordのいずれかを指定していないとき" do
    it "エラーが返る" do
      user = User.new(name: "foo", email: "foo@example.com")
      expect(user.invalid?).to be true
      expect(user.errors.details[:password][0][:error]).to eq :blank
    end
  end

  context "同じ名前のemailが存在しているとき" do
    it "エラーが返る" do
      User.create!(name: "foo", email: "foo@example.com", password: "abc123")
      user = User.new(name: "abc", email: "foo@example.com", password: "cde")
      expect(user.invalid?).to be true
      expect(user.errors.details[:email][0][:error]).to eq :taken
    end
  end
end
