class ItemsController < ApplicationController

  before_action :find_item, only: [:show, :edit, :update, :destroy, :upvote, :crop_image]
  before_action :check_if_admin, only: [:edit, :update, :new, :create, :destroy]

  def index
    @items = Item
    @items = @items.where("price >= ?", params[:price_from])       if params[:price_from]
    @items = @items.where("created_at >= ?", 0.day.ago)            if params[:today]
    @items = @items.where("votes_count >= ?", params[:votes_from]) if params[:votes_from]
    @items = @items.order("votes_count DESC", "price DESC")
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

  # /items POST
  def create
    item_params = params.require(:item).permit(:name, :description, :price, :weight, :real)
    @item = Item.create(item_params)
    if @item.errors.empty?
      redirect_to crop_image_item_path(@item)
    else
      render "new"
    end
  end

  # /items/1 PUT
  def update
    item_params = params.require(:item).permit(:name, :description, :price, :weight, :real, :image)
    @item.update_attributes(item_params)
    if @item.errors.empty?
      redirect_to crop_image_item_path(@item)
    else
      render "edit"
    end
  end

  def destroy
    @item.destroy
    redirect_to action: "index"
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

 
end
