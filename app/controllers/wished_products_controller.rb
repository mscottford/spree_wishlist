class WishedProductsController < Spree::BaseController
  respond_to :html

  def create
    @wished_product = WishedProduct.new(params[:wished_product])
    @wishlist = current_user.wishlist

    if @wishlist.include? params[:wished_product][:variant_id]
      @wished_product = @wishlist.wished_products.detect {|wp| wp.variant_id == params[:wished_product][:variant_id].to_i }
    else
      @wished_product.wishlist = current_user.wishlist
      @wished_product.save
    end

    Rails.logger.warn("Requested format: #{request.format.inspect}")
    Rails.logger.warn("Wishlist URL: #{wishlist_url(@wishlist).inspect}")

    respond_with(@wished_product) do |format|
      format.html { 
        Rails.logger.warn('Inside html format before redirect.')
        redirect_to wishlist_url(@wishlist) 
      }
    end
  end

  def update
    @wished_product = WishedProduct.find(params[:id])
    @wished_product.update_attributes(params[:wished_product])

    respond_with(@wished_product) do |format|
      format.html { redirect_to wishlist_url(@wished_product.wishlist) }
    end
  end

  def destroy
    @wished_product = WishedProduct.find(params[:id])
    @wished_product.destroy

    respond_with(@wished_product) do |format|
      format.html { redirect_to wishlist_url(@wished_product.wishlist) }
    end
  end
end
