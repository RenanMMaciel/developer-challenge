class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  def index
    @orders = Order.all
    render json: @orders
  end

  # GET /orders/:id
  def show
    render json: @order
  end

  # POST /orders
  def create
    if order_params_present_and_valid?
      @order = Order.new(order_params)
      if @order.save
        render json: @order, status: :created
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid or missing order parameters' }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/:id
  def update
    if order_params_present_and_valid?
      if @order.update(order_params)
        render json: @order
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid or missing order parameters' }, status: :unprocessable_entity
    end
  end

  # DELETE /orders/:id
  def destroy
    @order.destroy
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :customer_name,
      components: [
        :cpu_id,
        :motherboard_id,
        { memories: [:memory_id, { selected_sizes: [] }] },
        :gpu_id
      ]
    )
  end

  def order_params_present_and_valid?
    order_params_present? && order_params_valid_types?
  end

  def order_params_present?
    params.key?(:order) &&
    params[:order].key?(:customer_name) &&
    params[:order].key?(:components) && params[:order][:components].present?
  end

  def order_params_valid_types?
    customer_name = params[:order][:customer_name]
    components = params[:order][:components].to_unsafe_h

    customer_name.is_a?(String) &&
    components.is_a?(Hash) &&
    (!components.key?(:cpu_id) || components[:cpu_id].is_a?(Integer)) &&
    (!components.key?(:motherboard_id) || components[:motherboard_id].is_a?(Integer)) &&
    (!components.key?(:gpu_id) || components[:gpu_id].is_a?(Integer)) &&
    (components[:memories].nil? || (components[:memories].is_a?(Array) &&
      components[:memories].all? { |memory| memory.is_a?(Hash) && memory[:memory_id].is_a?(Integer) && memory[:selected_sizes].is_a?(Array) }))
  end
end
