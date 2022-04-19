class CaptionsController < ApplicationController
  before_action :set_caption, only: %i[ show destroy ]

  # GET /captions
  def index
    @captions = Caption.all

    render json: @captions
  end

  # GET /captions/:id
  def show
    render json: @caption
  end

  # POST /captions
  def create
    @caption = Caption.new(caption_params)

    if @caption.save
      render json: @caption, status: :created, location: @caption
    else
      render json: @caption.errors, status: :unprocessable_entity
    end
  end

  # DELETE /captions/:id
  def destroy
    @caption.destroy
  end

  private
    def set_caption
      @caption = Caption.find(params[:id])
    end

    def caption_params
      params.fetch(:caption, {})
      #params.require(:caption).permit(:url, :text)
    end
end
