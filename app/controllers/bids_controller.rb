class BidsController < ApplicationController
  def new

  end

  def create
    if not user_signed_in?
      redirect_to new_user_session_path, notice: "Please Sign In to bid" and return
    end

    @product = Product.find(params[:product])

    if(not @product.is_active?)
      flash[:notice] = "The auction for this Product has ended"
      redirect_to product_path(@product)and return
    end

    if(@product.user == current_user)
      flash[:notice] = "You cannot bid on your own product"
       redirect_to product_path(@product) and return
    end

    @bid = Bid.new(params[:bid])
    @bid.user = current_user
    @bid.product = @product

    logger.info(@product.current_price)
    logger.info(@bid.price)
    if(@product.current_price!=nil and @product.current_price >= @bid.price)
      flash[:notice] = "You must bid higher than the current price."
      redirect_to product_path(@product) and return
    end

    @bid.user.add_to_watch_list!(@product)

    respond_to do |format|
      if @bid.save
        @product.update_attributes(:current_price => @bid.price)
        flash[:notice] = "You have successfully bid on the item."

        # send emails to all users in watch list
        @product.watch_list_users.each do |user|
          Notifier.new_bid_added(@product, user).deliver
        end

        redirect_to product_path(@product) and return
      else
        flash[:notice] = "Error bidding on item."
        redirect_to product_path(@product) and return
      end
    end
  end

  def show
    if (@bid != nil)
      @bid = Bid.find(params[:id])
    end
  end
end
