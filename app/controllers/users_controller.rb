class UsersController < ActionController::Base
  protect_from_forgery

  def index
    @products = Product.search(params[:search]).paginate(page: params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  def my_bids
    if user_signed_in?
      @wonBids = current_user.get_bids_won
      if(@wonBids != nil and @wonBids != [])
        @wonBids = @wonBids.paginate(page: params[:wonBids], :per_page => 3)
      end
      @lostBids = current_user.get_bids_lost
      if(@lostBids != nil and @lostBids != [])
        @lostBids = @lostBids.paginate(page: params[:lostBids], :per_page => 3)
      end
      @openBids = current_user.get_bids_open
      if(@openBids != nil and @openBids != [])
        @openBids = @openBids.paginate(page: params[:openBids], :per_page => 3)
      end

      respond_to do |format|
        format.html #my_bids.html.erb
      end

    else
      session[:user_return_to] = request.referer
      redirect_to new_user_session_path, notice: 'Please Sign In to see your bids'
    end

  end

  def watch_list
    if user_signed_in?
      @products = current_user.watch_list_products.search(params[:search]).paginate(page: params[:page], :per_page => 10)

      respond_to do |format|
        format.html #watch_list.html.erb
      end

    else
      session[:user_return_to] = request.referer
      redirect_to new_user_session_path, notice: 'Please Sign In to see watch list'
    end
  end

  def add_to_watch_list
    @product = Product.find(params[:format])
    if not current_user.in_watch_list?(@product)
      current_user.add_to_watch_list!(@product)
    end
    redirect_to root_path
  end

  def remove_from_watch_list
    @product = Product.find(params[:format])
    if current_user.in_watch_list?(@product)
      current_user.remove_from_watch_list!(@product)
    end
    redirect_to watch_list_path
  end
end
