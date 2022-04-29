require 'pry'

class CaptionsController < ActionController::API
  before_action :set_caption, only: %i[ show destroy ]

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found_handler  

  # GET /captions
  def index
    @captions = Caption.all

    render json: { "captions": @captions }
  end

  # GET /captions/:id
  def show
      render json: { "caption": @caption }, status: :ok
  end

  # POST /captions
  def create
    @caption = Caption.new(caption_params)

    # TODO: replace this with caption_url generator and image creator
    @caption.caption_url = "http://127.0.0.1:3000/image"

    if @caption.save
      render json: { "caption": @caption }, status: :created, location: @caption.caption_url
    else
      render json: @caption.errors, status: :unprocessable_entity
    end
  end

  def image
    render status: :success
  end

  # DELETE /captions/:id
  def destroy
    if @caption.destroy
      render status: :ok
    else
      render json: @caption.errors, status: :unprocessable_entity
    end
  end

  private

  def set_caption
    @caption = Caption.find(params[:id])
  end

  def caption_params
    params.require(:caption).permit(:url, :text)
  end

  def not_found_handler(exception)  
    body = {
      "code": "caption_not_found",
      "title": "Caption not found by id",
      "description": "No Caption with provided id was found."
    }.to_json

    render json: body, status: :not_found
  end
end
