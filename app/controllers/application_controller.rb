class ApplicationController < ActionController::Base
  protect_from_forgery

  def layout_by_resource
    if devise_controller?
      "devise_layout"
    else
      "application"
    end
  end

  def after_sign_in_path_for(resource)
  	user_root_path
  end

  def after_sign_out_path_for(resource_or_scope)
  	root_path
  end

  def index
    @products = Product.search(params[:search]).paginate(page: params[:page], :per_page => 5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end
end
