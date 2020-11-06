class UserStocksController < ApplicationController

  # Check to see if the stock already exists and if it doesn't then lookup the stock, save it,
  # and then create a new association of the stock with the current user
  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
      @user_stock = UserStock.create(user: current_user, stock: stock)
      flash[:notice] = "Stock #{stock.name} was successfully added to you portfolio"
      redirect_to my_portfolio_path
    end

  end

end
