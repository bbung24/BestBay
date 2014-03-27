class Notifier < ActionMailer::Base
  default from: "noreply@mighty-river-6835.herokuapp.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.bid_time_ended.subject
  #
  def won_the_bid(product, user)
    @product=product
    @user=user

    mail to: @user.email, subject: "Bid Winner for #{@product.title}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.bid_time_ended.subject
  #
  def bid_time_ended(product, user)
    @product=product
    @user=user

    mail to: @user.email, subject: "Bid time ended for #{@product.title}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.new_bid_added.subject
  #
  # Email Format:
  # New bid on product <product_title>
  # Dear <user>,
  # A new bid is added to <product_title>.
  #
  # In order to view the the new Bid and history, please visit following link:
  # <url of the product>
  #
  def new_bid_added(product, user)
    @product=product
    @user=user

    mail to: @user.email, subject: "New bid on product #{@product.title}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.product_information_changed.subject
  #
  def product_information_changed(product, user)
    @product=product
    @user=user

    mail to: @user.email, subject: "Product information changed for #{product.title}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.product_retracted.subject
  #
  def product_retracted(product,user)
    @product=product
    @user=user

    mail to: @user.email, subject: "Product Retracted: #{product.title}"
  end
end
