class Order < ApplicationRecord
  validate :components_compatibility

  private

  def components_compatibility
    unless components_compatible?
      errors.add(:components, "Os componentes selecionados não são compatíveis.")
    end
  end

  def components_compatible?
    cpu = Component.find_by(id: components["cpu_id"])
    motherboard = Component.find_by(id: components["motherboard_id"])
    memories = components["memories"]
    gpu = Component.find_by(id: components["gpu_id"])

    unless cpu.present? && motherboard.present? && memories.present?
      errors.add(:components, "Processador, placa-mãe e memória RAM são componentes obrigatórios.")
      return false
    end

    if [cpu, motherboard, gpu].count(nil) > 1
      errors.add(:components, "O computador pode ter apenas um processador, uma placa-mãe e uma GPU.")
      return false
    end

    unless motherboard_supports_cpu?(motherboard, cpu)
      supported_brands = motherboard.specifications["supported_cpu_brands"]
      supported_brands_text = supported_brands.size == 1 ? supported_brands.first : supported_brands.join(" e ")
      errors.add(:components, "A placa-mãe selecionada não suporta a marca do processador selecionado. Marcas de processador suportadas: #{supported_brands_text}.")
      return false
    end

    unless total_memory_slots_valid?(motherboard, memories)
      motherboard_memory_slots_text = motherboard.specifications["max_memory_slots"]
      errors.add(:components, "A quantidade de memória RAM selecionada é superior à quantidade de slots da placa-mãe (#{motherboard_memory_slots_text}).")
      return false
    end

    unless total_memory_size_valid?(motherboard, memories)
      motherboard_memory_size_text = motherboard.specifications["max_memory_size"]
      errors.add(:components, "A quantidade total de GB de memória RAM selecionada é superior à capacidade suportada pela placa-mãe (#{motherboard_memory_size_text}GB).")
      return false
    end

    unless gpu_valid?(motherboard, gpu)
      errors.add(:components, "A placa-mãe selecionada não suporta vídeo integrado e é necessário selecionar uma placa de vídeo.")
      return false
    end

    return true
  end

  def motherboard_supports_cpu?(motherboard, cpu)
    return false unless motherboard && cpu
    supported_brands = motherboard.specifications["supported_cpu_brands"] || []
    cpu_brand = cpu.specifications["brand"] || ""
    return supported_brands.include?(cpu_brand)
  end

  def total_memory_slots_valid?(motherboard, memories)
    return false unless motherboard && memories
    total_selected_slots = memories.sum { |memory| memory["selected_sizes"].size }
    return total_selected_slots <= (motherboard.specifications["max_memory_slots"] || 0)
  end

  def total_memory_size_valid?(motherboard, memories)
    return false unless motherboard && memories
    total_memory_size = memories.sum { |memory| memory["selected_sizes"].sum }
    return total_memory_size <= (motherboard.specifications["max_memory_size"] || 0)
  end

  def gpu_valid?(motherboard, gpu)
    return false unless motherboard && gpu
    integrated_video_support = motherboard.specifications["integrated_video_support"]
    return integrated_video_support == false && !gpu.nil?
  end
end
