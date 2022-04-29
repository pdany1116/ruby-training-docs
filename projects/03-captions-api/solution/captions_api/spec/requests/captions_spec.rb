require 'rails_helper'
require 'pry'
require 'uri'

RSpec.describe "/captions", type: :request do
  describe "GET /captions" do
    subject(:get_captions) { get "/captions" }

    context "with existing captions" do
      before do
        list = FactoryBot.create_list(:caption, 5)
      end

      it "responds with OK" do
        get_captions

        expect(response).to have_http_status(200)
      end

      it "return an array of captions with size 5 as JSON" do
        get_captions

        captions = JSON.parse(response.body)["captions"]
        expect(captions.size).to eq 5
      end
    end

    context "with non existing captions" do
      it "responds with OK" do
        get_captions

        expect(response).to have_http_status(200)
      end

      it "returns an empty array as JSON" do
        get_captions

        captions = JSON.parse(response.body)["captions"]
        expect(captions.size).to eq 0
      end
    end
  end

  describe "GET /captions/:id" do
    subject(:get_captions) { get "/captions/#{my_caption.id}" }

    context "with existing caption" do
      let (:my_caption) { FactoryBot.create(:caption) }

      it "responds with OK" do
        get_captions

        expect(response).to have_http_status(200)
      end

      it "returns specified caption as JSON" do
        get_captions

        body = JSON.parse(response.body)
        expect(body["caption"]["url"]).to eq my_caption.url
        expect(body["caption"]["text"]).to eq my_caption.text
        expect(body["caption"]["caption_url"]).to eq my_caption.caption_url
      end
    end

    context "with non existing caption" do
      let (:my_caption) do
         caption = FactoryBot.build(:caption)
         caption.id = 0

         caption
      end

      it "retruns not found" do
        get_captions

        expect(response).to have_http_status(404)
      end

      it "returns a not found error json message" do
        get_captions

        body = JSON.parse(response.body)
        expect(body["code"]).to eq "caption_not_found"
      end
    end
  end

  describe "POST /captions" do
    subject(:post_captions) { post "/captions", params: params }

    context "with valid parameters" do
      let(:params) do
        {
          caption: {
            url: "https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg",
            text: "Hi mom!"
          }
        }
      end

      it "responds with created" do
        post_captions

        expect(response).to have_http_status(201)
      end

      it "creates a new caption" do
        post_captions

        get "/captions"
        captions = JSON.parse(response.body)["captions"]
        caption = captions[0]

        expect(captions.size).to eq 1
        expect(caption["url"]).to eq params[:caption][:url]
        expect(caption["text"]).to eq params[:caption][:text]
        expect(caption["caption_url"] =~ URI::regexp).to eq 0
      end

      it "returns the new added caption as JSON" do
        post_captions

        body = JSON.parse(response.body)
        expect(body["caption"]["url"]).to eq params[:caption][:url]
        expect(body["caption"]["text"]).to eq params[:caption][:text]
        expect(body["caption"]["caption_url"] =~ URI::regexp).to eq 0
        expect(body["caption"]["caption_url"]).to eq response.location
      end
    end

    context "with invalid parameters" do
      it "does not create a new Caption, returns 400",
      :skip => "Not implemented yet!" do

        expect(response).to have_http_status(400)
      end

      it "renders a JSON response with errors for the new caption",
      :skip => "Not implemented yet!" do

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE /captions" do
    subject(:delete_captions) { delete "/captions/#{my_caption.id}" }
    
    context "with existing caption" do
      let (:my_caption) { FactoryBot.create(:caption) }

      it "returns ok" do
        delete_captions
  
        expect(response).to have_http_status(200)
      end
    end

    context "with not existing caption" do
      let (:my_caption) do
        caption = FactoryBot.build(:caption)
        caption.id = 0

        caption
      end
      
      it "returns not found" do
        delete_captions

        expect(response).to have_http_status(404)
      end

      it "returns a not found error json message" do
        delete_captions

        body = JSON.parse(response.body)
        expect(body["code"]).to eq "caption_not_found"
      end
    end
  end
end
