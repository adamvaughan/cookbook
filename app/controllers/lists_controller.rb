class ListsController < ApplicationController
  def show
    plan = Plan.find(params[:plan_id])
    @list = plan.list || ListGenerator.generate!(plan)

    respond_to do |format|
      format.json
      format.html { render_blank_page }
    end
  end

  def destroy
    plan = Plan.find(params[:plan_id])
    plan.list.try(:destroy)
    head :ok
  end
end
