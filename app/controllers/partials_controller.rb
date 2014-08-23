class PartialsController < ApplicationController
  def index
    render_blank_page
  end

  def show
    partials_directory = File.join(Rails.root, 'app', 'views', 'partials')
    path = File.expand_path(File.join(partials_directory, "#{params[:name]}.html"))

    if path.match(Regexp.new("^#{Regexp.escape(partials_directory)}"))
      send_file path, type: 'text/html; charset=utf-8', disposition: :inline
    else
      head :not_found
    end
  end
end
