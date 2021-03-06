class ItemsController < ApplicationController

  before_action :find_item, only: [:show, :edit, :update, :destroy, :upvote, :crop_image]
  before_action :check_if_admin, only: [:edit, :update, :new, :create, :destroy]

  def index
    @items = Rails.cache.fetch(items_cache_key, expires_in: 12.hours) do
      items = Item
      items = items.where("price >= ?", params[:price_from])       if params[:price_from]
      items = items.where("created_at >= ?", 0.day.ago)            if params[:today]
      items = items.where("votes_count >= ?", params[:votes_from]) if params[:votes_from]
      items = items.order("votes_count DESC", "price")
      items = items.page(params[:page]).per(10)
      items = Kaminari::PaginatableArray.new(items.to_a, limit: items.limit_value, offset: items.offset_value, total_count: items.total_count)
    end
  end

  def expensive
    @items = Item.where("price > 1000")
    render "index"
  end

  def show
    unless @item
      render text: "Page not found", status: 404
    end
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    Rails.cache.clear
    @item = Item.create(item_params)
    if @item.errors.empty?
      redirect_to crop_image_item_path(@item)
    else
      render "new"
    end
  end

  # /items/1 PUT
  def update
    @item.update_attributes(item_params)
    if @item.errors.empty?
      flash[:success] = "Item successfully updated!"
      redirect_to crop_image_item_path(@item)
    else
      flash.now[:error] = "You made mistakes in your form! Please correct them."
      render "edit"
    end
  end

  def destroy
    @item.destroy
    render json: { success: true }
    ItemsMailer.item_destroyed(@item).deliver
  end

  def upvote
    @item.increment!(:votes_count)
    redirect_to action: :index
  end

  def crop_image
    if request.put?
      @item.crop_image!(params[:item][:image_crop_data])
      redirect_to item_path(@item)
    end
  end

  private

  def find_item
    @item = Item.where(id: params[:id]).first
    render_404 unless @item
  end

  def item_params
    params.require(:item).permit(:name, :description, :price, :weight, :real, :image)
  end

  def items_cache_key
    "items_cache:#{params[:price_from]}:#{params[:votes_from]}:#{params[:today]}:#{params[:page] || 1}"
  end

end
