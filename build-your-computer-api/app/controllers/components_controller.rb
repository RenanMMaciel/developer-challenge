class ComponentsController < ApplicationController
  before_action :set_component, only: [:show, :update, :destroy]

  # GET /components
  def index
    if params[:component_type]
      @components = Component.where(component_type: params[:component_type])
    else
      @components = Component.all
    end
    render json: @components
  end

  # GET /components/:id
  def show
    render json: @component
  end

  # POST /components
  def create
    if components_params_present_and_valid?
      @component = Component.new(component_params)
      if @component.save
        render json: @component, status: :created
      else
        render json: @component.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Component parameters are missing or invalid" }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /components/:id
  def update
    if @component.present? && components_params_present_and_valid?
      if @component.update(component_params)
        render json: @component
      else
        render json: @component.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Component not found or parameters are missing or invalid" }, status: :unprocessable_entity
    end
  end

  # DELETE /components/:id
  def destroy
    @component.destroy
  end

  private

  def set_component
    @component = Component.find(params[:id])
  end

  def component_params
    params.require(:component).permit(:name, :component_type, specifications: [
      :brand, :supported_cpu_brands, :max_memory_slots, :max_memory_size, :integrated_video_support, :available_sizes
    ])
  end

  def components_params_present_and_valid?
    components_params_present? && components_params_valid_types?
  end

  def components_params_present?
    params[:component].key?(:name) && params[:component][:name].present? &&
    params[:component].key?(:component_type) && params[:component][:component_type].present? &&
    params[:component].key?(:specifications) && params[:component][:specifications].present?
  end

  def components_params_valid_types?
    name = params[:component][:name]
    component_type = params[:component][:component_type]
    specifications = params[:component][:specifications].to_unsafe_h

    validate_name_and_component_type(name, component_type) && validate_specifications_type(specifications) &&
    case component_type
    when "cpu"
      validate_cpu(specifications)
    when "motherboard"
      validate_motherboard(specifications)
    when "memory"
      validate_memory(specifications)
    when "gpu"
      validate_gpu(specifications)
    else
      false
    end
  end

  def validate_name_and_component_type(name, component_type)
    name.is_a?(String) && component_type.is_a?(String)
  end

  def validate_specifications_type(specifications)
    specifications.is_a?(Hash)
  end

  def validate_cpu(specifications)
    specifications.key?(:brand) && specifications[:brand].present? &&
    specifications[:brand].is_a?(String)
  end

  def validate_motherboard(specifications)
    specifications.key?(:supported_cpu_brands) && specifications[:supported_cpu_brands].present? &&
    specifications[:supported_cpu_brands].is_a?(Array) &&
    specifications[:supported_cpu_brands].all? { |brand| brand.is_a?(String) } &&
    specifications.key?(:max_memory_slots) && specifications[:max_memory_slots].present? &&
    specifications[:max_memory_slots].is_a?(Integer) &&
    specifications.key?(:max_memory_size) && specifications[:max_memory_size].present? &&
    specifications[:max_memory_size].is_a?(Integer) &&
    specifications.key?(:integrated_video_support) && specifications[:integrated_video_support].present? &&
    [true, false].include?(specifications[:integrated_video_support])
  end

  def validate_memory(specifications)
    specifications.key?(:available_sizes) && specifications[:available_sizes].present? &&
    specifications[:available_sizes].is_a?(Array) &&
    specifications[:available_sizes].all? { |size| size.is_a?(Integer) }
  end

  def validate_gpu(specifications)
    specifications.empty?
  end
end
