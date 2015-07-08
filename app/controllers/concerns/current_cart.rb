module CurrentCart
  extend ActiveSupport::Concern

  private
  
  def set_cart
    @cart = Cart.find(session[:card_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:card_id] = @cart.id
    #@cart ||= Cart.find_by(id:session[:card_id])
  end
end
