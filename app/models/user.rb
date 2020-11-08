class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def self.user_search(param)
    # Will get rid of any blank spaces in search
    param.strip!
    # see if param matches any of the fields, concatenates them, and returns only the unique values
    # so you will not receive duplicates
    to_send_back = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    # if it there is nothing to return it will return nil otherwise it will return the matched value
    return nil unless to_send_back
    to_send_back
  end

  # these matches methods are what will be called with the appropriate field name for user_search
  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end


  # Takes in field name and searches for a match based on a similar string
  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

end
