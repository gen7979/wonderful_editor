require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  before { @params = attributes_for(:user) }

  context '適切なパラメータを送信したとき'do
    subject do
      post api_v1_user_registration_path, params: {
        name: @params[:name],
        email: @params[:email],
        password: @params[:password]
      }
    end
    it '新規登録ができる' do
      expect { subject }.to change { User.count }.by(1)

      res = response.parsed_body
      expect(res["data"]["name"]).to eq @params[:name]
      expect(res["data"]["email"]).to eq @params[:email]
      expect(response.status).to eq(200)
    end
    it "header 情報を取得することができる" do
      subject
      header = response.header
      expect(header["access-token"]).to be_present
      expect(header["client"]).to be_present
      expect(header["expiry"]).to be_present
      expect(header["uid"]).to be_present
      expect(header["token-type"]).to be_present
    end
  end

  context '不適切なパラメータを送信したとき'do
    subject do
      post api_v1_user_registration_path, params: {
        email: @params[:email],
        password: @params[:password]
      }
    end
    it 'エラーになる'do
      subject
      res = response.parsed_body
      expect(res["status"]).to eq "error"
      expect(res["errors"]["name"]).to eq ["can't be blank"]
      expect(res["errors"]["full_messages"]).to eq ["Name can't be blank"]
    end
  end
end
