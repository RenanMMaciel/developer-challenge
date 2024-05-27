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

    errors_found = false

    unless cpu.present? && motherboard.present? && memories.present?
      errors.add(:components, "Processador, placa-mãe e memória RAM são componentes obrigatórios.")
      errors_found = true
    end

    if [cpu, motherboard, gpu].count(nil) > 1
      errors.add(:components, "O computador pode ter apenas um processador, uma placa-mãe e uma GPU.")
      errors_found = true
    end

    if motherboard && cpu && !motherboard_supports_cpu?(motherboard, cpu)
      supported_brands = motherboard.specifications["supported_cpu_brands"]
      supported_brands_text = supported_brands.size == 1 ? supported_brands.first : supported_brands.join(" e ")
      errors.add(:components, "A placa-mãe selecionada não suporta a marca do processador selecionado. Marcas de processador suportadas: #{supported_brands_text}.")
      errors_found = true
    end

    if motherboard && memories && !total_memory_slots_valid?(motherboard, memories)
      motherboard_memory_slots_text = motherboard.specifications["max_memory_slots"]
      errors.add(:components, "A quantidade de memória RAM selecionada é superior à quantidade de slots da placa-mãe (#{motherboard_memory_slots_text}).")
      errors_found = true
    end

    if motherboard && memories && !total_memory_size_valid?(motherboard, memories)
      motherboard_memory_size_text = motherboard.specifications["max_memory_size"]
      errors.add(:components, "A quantidade total de GB de memória RAM selecionada é superior à capacidade suportada pela placa-mãe (#{motherboard_memory_size_text}GB).")
      errors_found = true
    end

    if motherboard && !gpu_valid?(motherboard, gpu)
      errors.add(:components, "A placa-mãe selecionada não suporta vídeo integrado e é necessário selecionar uma placa de vídeo.")
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

  def gpu_valid?(motherboard, gpu)
    return false unless motherboard
    integrated_video_support = motherboard.specifications["integrated_video_support"]
    integrated_video_support == false && !gpu.nil?
  end
end
