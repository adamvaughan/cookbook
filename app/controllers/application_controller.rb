class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def render_blank_page
    render 'partials/blank'
  end
end
