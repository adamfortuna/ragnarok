class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  include Pagy::Backend

  # GET /items
  def index
    if params[:q]
      @pagy, @items = pagy(Item.ransack(name_cont: params[:q]).result(distinct: true), items: 50)
    else
      @pagy, @items = pagy(Item.order(:name), items: 100)
    end
  end

  # GET /items/1
  def show
  end

  def opportunities
    @items = Item.opportunities
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.require(:item).permit(:uid, :unique_name, :name, :type, :subtype, :npc_price, :slots, :icon)
    end
end
