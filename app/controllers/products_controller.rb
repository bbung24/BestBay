class ProductsController < ApplicationController

  def new
    if user_signed_in?
      @product = Product.new
      #@product.price=999
    else
      # TO:DO -- Add a flash message and redirect to Add Item Page after Login
      redirect_to new_user_session_path, notice: 'Please Sign In to post new Product'
    end
  end

  def create
    @product = Product.new(params[:product])
    @product.user = current_user
    logger.info(">>in create")
    respond_to do |format|
      if @product.save
        Xtremers::Application::SCHEDULER.at @product.deadline do
          @product.close_auction
        end
        format.html { redirect_to product_path(@product), notice: 'You have successfully posted an item.' }
      else
        format.html { render 'new' }
      end
    end
  end

  def picture
    product_id = params[:id]
    @picture = ProductPicture.find_by_product_id(product_id)
    if (@picture != nil)
      send_data(@picture.image_data, :filename => @picture.name, :type => @picture.content_type, :disposition => "inline")
    else
      @picture = ProductPicture.new
      @picture.name = "Default"
    end
  end

  def show
    @product = Product.find(params[:id])
    @bid = Bid.new
    @bids = @product.bids
  end

  def active
    if user_signed_in?
      @active_products = current_user.get_active_products.paginate(page: params[:page], :per_page => 4)
      @closed_products = current_user.get_closed_products.paginate(page: params[:page], :per_page => 4)
      render  'application/index'
    else
      session[:user_return_to] = request.referer
      redirect_to new_user_session_path, notice: 'Please Sign In to see active products'
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(params[:product])
      flash[:success] = "Product Updated Successfully"

      # send emails to all users in watch list
      @product.watch_list_users.each do |user|
        Notifier.product_information_changed(@product, user).deliver
      end

      redirect_to product_path(@product)
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    watch_list_users = @product.watch_list_users
    @product.destroy

    # send emails to all users in watch list
    watch_list_users.each do |user|
      Notifier.product_retracted(@product, user).deliver
    end

    respond_to do |format|
      format.html do
        flash[:success] = "Item named #{@product.title} deleted successfully"
        redirect_to user_active_products_path
      end
      format.js
    end
  end

  end