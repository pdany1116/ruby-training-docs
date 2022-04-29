require 'pry'

class CaptionsController < ApplicationController
  before_action :set_caption, only: %i[ show destroy ]

  # GET /captions
  def index
    @captions = Caption.all

    render json: { "captions": @captions }
  end

  # GET /captions/:id
  def show
    if @caption.nil?
      render json: "", status: :not_found
    else
      render json: { "caption": @caption }, status: :ok
    end
  end

  # POST /captions
  def create
    @caption = Caption.new(caption_params)

    # TODO: pass caption to instagram caption creator
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
    @caption.destroy
  end

  private

  def set_caption
    @caption = Caption.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    @caption = nil
  end

  def caption_params
    params.require(:caption).permit(:url, :text)
  end
end
