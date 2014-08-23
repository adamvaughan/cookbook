class PlansController < ApplicationController
  def index
    @plans = Plan.all

    respond_to do |format|
      format.json
      format.html { render_blank_page }
    end
  end

  def show
    @plan = Plan.find(params[:id])

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
    @plan = Plan.new(plan_params)

    if @plan.save
      render 'show'
    else
      logger.info "Failed to save Plan: #{@plan.errors.inspect}"
      render json: @plan.errors, status: :unprocessable_entity
    end
  end

  def edit
    respond_to do |format|
      format.html { render_blank_page }
    end
  end

  def update
    @plan = Plan.find(params[:id])

    if @plan.update_attributes(plan_params)
      render 'show'
    else
      logger.info "Failed to save Plan: #{@plan.errors.inspect}"
      render json: @plan.errors, status: :unprocessable_entity
    end
  end

  def destroy
    plan = Plan.find(params[:id])
    plan.destroy
    head :no_content
  end

  private

  def plan_params
    attributes = params
      .require(:plan)
      .permit(
        :month,
        :year,
        meals: [
          :id,
          :day,
          :recipeId,
          :_destroy
        ])

    if attributes['meals']
      attributes['meals'].each do |meal_attributes|
        meal_attributes['recipe_id'] = meal_attributes.delete('recipeId')
      end

      attributes['meals_attributes'] = attributes.delete('meals') || []
    end

    attributes
  end
end
