class ListsController < ApplicationController
  def show
    plan = Plan.find(params[:plan_id])
    @list = plan.list || ListGenerator.generate!(plan)

    respond_to do |format|
      format.json
      format.html { render_blank_page }
    end
  end

  def edit
    respond_to do |format|
      format.html { render_blank_page }
    end
  end

  def update
    plan = Plan.find(params[:plan_id])
    @list = plan.list

    if @list.update_attributes(list_params)
      render 'show'
    else
      logger.info "Failed to save List: #{@list.errors.inspect}"
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def destroy
    plan = Plan.find(params[:plan_id])
    plan.list.try(:destroy)
    head :ok
  end

  private

  def list_params
    attributes = params
      .require(:list)
      .permit(
        items: [
          :id,
          :quantity,
          :measurement,
          :description,
          :purchased,
          :manuallyAdded,
          :_destroy
        ]
      )

    if attributes['items']
      attributes['items'].each do |item_attributes|
        item_attributes['manually_added'] = item_attributes.delete('manuallyAdded')
      end

      attributes['list_items_attributes'] = attributes.delete('items') || []
    end

    attributes
  end
end
