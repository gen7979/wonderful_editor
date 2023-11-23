require 'rails_helper'

RSpec.describe "Articles", type: :request do

  #index
  describe "GET /api/v1/articles" do
    subject {get(api_v1_articles_path)}
    before {
      user = create(:user)
      3.times{create(:article,user_id: user.id )}
    }
    it "記事一覧を閲覧できる" do
      subject

      # binding.pry
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["title", "updated_at"]
      expect(response).to have_http_status(200)
    end
  end

  #show
  describe "GET /api/v1/articles/:id" do
    it "任意の記事が閲覧できる" do
    end
  end

  #create
  describe "POST /api/v1/articles" do
    it "記事を新規作成できる" do
    end
  end

  #update
  describe "PATCH /api/v1/articles/:id" do
    it "任意の記事を更新できる" do
    end
  end

  #DELETE
  describe "DELETE /api/v1/articles/:id " do
    it "任意の記事を削除できる" do
    end
  end
end
