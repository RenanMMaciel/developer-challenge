class Order < ApplicationRecord
  validate :validate_components_compatibility, if: :validate_components_existence

  def validate_components_existence
    cpu_id = components["cpu_id"]
    motherboard_id = components["motherboard_id"]
    memories = components["memories"]
    gpu_id = components["gpu_id"]
    errors_found = false

    if components.key?(:cpu_id)
      unless Component.exists?(id: cpu_id)
        errors.add(:order, "The processor id does not exist.")
        errors_found = true
      else
        cpu = Component.find(cpu_id)
        if cpu.component_type != "cpu"
          errors.add(:order, "The processor id does not correspond to a 'component_type' of type 'cpu'.")
          errors_found = true
        end
      end
    end

    if components.key?(:motherboard_id)
      unless Component.exists?(id: motherboard_id)
        errors.add(:order, "The motherboard id does not exist.")
        errors_found = true
      else
        motherboard = Component.find(motherboard_id)
        if motherboard.component_type != "motherboard"
          errors.add(:order, "The motherboard id does not correspond to a 'component_type' of type 'motherboard'.")
          errors_found = true
        end
      end
    end

    if components.key?(:memories)
      memories.each_with_index do |memory, index|
        memory_id = memory["memory_id"]
        unless Component.exists?(id: memory_id)
          errors.add(:order, "The RAM id [#{index}] does not exist.")
          errors_found = true
        else
          memory_component = Component.find(memory_id)
          if memory_component.component_type != "memory"
            errors.add(:order, "The RAM id [#{index}] does not correspond to a 'component_type' of type 'memory'.")
            errors_found = true
          end
        end
      end
    end

    if components.key?(:gpu_id)
      unless Component.exists?(id: gpu_id)
        errors.add(:order, "The graphics card id does not exist.")
        errors_found = true
      else
        gpu = Component.find(gpu_id)
        if gpu.component_type != "gpu"
          errors.add(:order, "The graphics card id does not correspond to a 'component_type' of type 'gpu'.")
          errors_found = true
        end
      end
    end

    !errors_found
  end

  def validate_components_compatibility
    cpu = Component.find_by(id: components["cpu_id"])
    motherboard = Component.find_by(id: components["motherboard_id"])
    memories = components["memories"]
    gpu = Component.find_by(id: components["gpu_id"])
    cpu_count = Component.where(id: components["cpu_id"]).count
    gpu_count = Component.where(id: components["gpu_id"]).count
    motherboard_count = Component.where(id: components["motherboard_id"]).count
    errors_found = false

    unless cpu.present? && motherboard.present? && memories.present?
      errors.add(:order, "Processor, motherboard and RAM are required components.")
      errors_found = true
    end

    if cpu_count > 1 || motherboard_count > 1 || gpu_count > 1
      errors.add(:order, "A computer can have just one processor, one motherboard and one GPU.")
      errors_found = true
    end

    if motherboard && cpu && !motherboard_supports_cpu?(motherboard, cpu)
      supported_brands = motherboard.specifications["supported_cpu_brands"]
      supported_brands_text = supported_brands.size == 1 ? supported_brands.first : supported_brands.join(" e ")
      errors.add(:order, "The selected motherboard does not support the selected processor brand. Supported processor brands: #{supported_brands_text}.")
      errors_found = true
    end

    if memories && (invalid_memories = selected_memory_sizes_valid?(memories)).present?
      invalid_memories.each do |memory_name, available_sizes|
        errors.add(:order, "Selected RAM memory size is not valid for '#{memory_name}'. Available sizes: #{available_sizes}.")
      end
      errors_found = true
    end

    if motherboard && memories && !total_memory_slots_valid?(motherboard, memories)
      motherboard_memory_slots_text = motherboard.specifications["max_memory_slots"]
      errors.add(:order, "The amount of RAM selected is greater than the number of slots on the motherboard (#{motherboard_memory_slots_text}).")
      errors_found = true
    end

    if motherboard && memories && !total_memory_size_valid?(motherboard, memories)
      motherboard_memory_size_text = motherboard.specifications["max_memory_size"]
      errors.add(:order, "The total amount of GB of RAM selected is greater than the capacity supported by the motherboard (#{motherboard_memory_size_text}GB).")
      errors_found = true
    end

    if motherboard && !needs_gpu?(motherboard, gpu)
      errors.add(:order, "The selected motherboard does not support integrated video and you must select a graphics card.")
      errors_found = true
    end

    !errors_found
  end

  def motherboard_supports_cpu?(motherboard, cpu)
    return false unless motherboard && cpu
    supported_brands = motherboard.specifications["supported_cpu_brands"] || []
    cpu_brand = cpu.specifications["brand"] || ""

    supported_brands.include?(cpu_brand)
  end

  def selected_memory_sizes_valid?(memories)
    return false unless memories
    invalid_memories = {}

    memories.each do |memory|
      memory_component = Component.find(memory["memory_id"])
      selected_sizes = memory["selected_sizes"] || []
      invalid_sizes = selected_sizes.reject do |size|
        memory_component.specifications["available_sizes"].include?(size)
      end
      unless invalid_sizes.empty?
        memory_name = memory_component.name || ""
        available_sizes = memory_component.specifications["available_sizes"].join(", ") || ""
        invalid_memories[memory_name] = available_sizes
      end
    end

    invalid_memories
  end

  def total_memory_slots_valid?(motherboard, memories)
    return false unless motherboard && memories
    total_selected_slots = memories.sum { |memory| memory["selected_sizes"].size }

    total_selected_slots <= (motherboard.specifications["max_memory_slots"] || 0)
  end

  def total_memory_size_valid?(motherboard, memories)
    return false unless motherboard && memories
    total_memory_size = memories.sum { |memory| memory["selected_sizes"].sum }

    total_memory_size <= (motherboard.specifications["max_memory_size"] || 0)
  end

  def needs_gpu?(motherboard, gpu)
    return true unless motherboard
    integrated_video_support = motherboard.specifications["integrated_video_support"]

    if integrated_video_support == false
      return gpu.present?
    else
      return true
    end
  end
end
