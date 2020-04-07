class ShopsController < ApplicationController
  before_action :set_shop, only: [:show]

  include Pagy::Backend

  # GET /shops
  def index
    @pagy, @shops = pagy(Shop.open.order(start_date: :desc), items: 200)
  end

  def vending
    @pagy, @shops = pagy(Shop.open.vending.order(start_date: :desc), items: 200)
    render :index
  end

  def buying
    @pagy, @shops = pagy(Shop.open.buying.order(start_date: :desc), items: 200)
    render :index
  end

  # GET /shops/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def shop_params
      params.require(:shop).permit(:title, :username, :location_map, :location_x, :location_y, :start_date, :shop_type, :open)
    end
end
