class ComponentsController < ApplicationController
  before_action :set_component, only: [:show, :update, :destroy]

  # GET /components
  def index
    @components = Component.all
    render json: @components
  end

  # GET /components/id
  def show
    render json: @component
  end

  # POST /components
  def create
    @component = Component.new(component_params)

    if @component.save
      render json: @component, status: :created
    else
      render json: @component.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /components/id
  def update
    if @component.update(component_params)
      render json: @component
    else
      render json: @component.errors, status: :unprocessable_entity
    end
  end

  # DELETE /components/id
  def destroy
    @component.destroy
  end

  private

  def set_component
    @component = Component.find(params[:id])
  end

  def component_params
    params.require(:component).permit(:name, :component_type, specifications: {})
  end
end
