require "rails_helper"

RSpec.describe "Articles" do
  # index
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article) }

    it "記事の一覧が取得できる" do
      subject
      res = response.parsed_body
      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res.pluck("id")).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  # show
  describe "GET /api/v1/articles/:id" do
    subject { get api_v1_article_path(article_id) }

    context "指定したidの記事が存在するとき" do
      let(:article_id) { article.id }
      let(:article) { create(:article) }
      it "任意の記事が閲覧できる" do
        subject
        res = response.parsed_body
        expect(response).to have_http_status(:ok)
        expect(res["title"]).to eq article.title
        expect(res["updated_at"]).to eq article.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
        expect(res["user"]["id"]).to eq article.user_id
      end
    end

    context "指定したidの記事が存在しないとき" do
      let(:article_id) { 100_000_000 }
      let(:article) { create(:article) }
      it "エラーが起こる" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  # # create
  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }

    # stub
    let(:headers) { current_user.create_new_auth_token }

    it "記事のレコードが作成できる" do
      expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)

      res = response.parsed_body
      expect(res["title"]).to eq params[:article][:title]
      expect(res["body"]).to eq params[:article][:body]
      expect(response).to have_http_status(:ok)
    end
  end

  # update
  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) do
      { article: { title: "ABC", body: article.body, created_at: 1.day.ago } }
    end
    let(:article_id) { article.id }
    let(:article) { create(:article) }
    let(:current_user) { create(:user) }

    let(:headers) { current_user.create_new_auth_token }

    it "正しいパラメータが送信された場合、任意の記事を更新できる" do
      expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                            not_change { article.reload.body } &
                            not_change { article.reload.created_at }
    end
  end

  # DELETE
  describe "DELETE /api/v1/articles/:id" do
    subject { delete api_v1_article_path(article_id), headers: headers }

    let(:article_id) { article.id }
    let!(:article) { create(:article, user: current_user) }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "任意の記事を削除できる" do
      expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end
