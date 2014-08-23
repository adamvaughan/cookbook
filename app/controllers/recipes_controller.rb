class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all

    respond_to do |format|
      format.json
      format.html { render_blank_page }
    end
  end

  def show
    @recipe = Recipe.find(params[:id])

    respond_to do |format|
      format.json
      format.html { render_blank_page }
    end
  end

  def new
    respond_to do |format|
      format.html { render_blank_page }
    end
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      render 'show'
    else
      logger.info "Failed to save Recipe: #{@recipe.errors.inspect}"
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  def edit
    respond_to do |format|
      format.html { render_blank_page }
    end
  end

  def update
    @recipe = Recipe.find(params[:id])

    if @recipe.update_attributes(recipe_params)
      render 'show'
    else
      logger.info "Failed to save Recipe: #{@recipe.errors.inspect}"
      render json: @recipe.errors, status: :unprocessable_entity
    end
  end

  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    head :no_content
  end

  private

  def recipe_params
    attributes = params
      .require(:recipe)
      .permit(
        :title,
        :notes,
        ingredients: [
          :id,
          :index,
          :quantity,
          :measurement,
          :description,
          :notes,
          :_destroy
        ],
        steps: [
          :id,
          :index,
          :description,
          :_destroy
        ])

    attributes['ingredients_attributes'] = attributes.delete('ingredients') || []
    attributes['steps_attributes'] = attributes.delete('steps') || []
    attributes
  end
end
