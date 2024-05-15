class Component < ApplicationRecord
  enum component_type: { cpu: 0, motherboard: 1, memory: 2, gpu: 3 }

  before_validation :validate_specifications_based_on_type

  def validate_specifications_based_on_type
    case component_type.to_sym
    when :cpu
      validate_cpu_specifications
    when :motherboard
      validate_motherboard_specifications
    when :memory
      validate_memory_specifications
    when :gpu
      validate_gpu_specifications
    end
  end

  def validate_cpu_specifications
    unless specifications.present? && specifications.key?("brand")
      errors.add(:specifications, "Necessário preencher a marca do processador.")
    end

    unless specifications["brand"].is_a?(String)
      errors.add(:specifications, "Especificações inválidas para CPU: 'brand' deve ser do tipo 'string'.")
    end
  end

  def validate_motherboard_specifications
    unless specifications.present? && specifications.key?("supported_cpu_brands") && specifications.key?("max_memory_slots") && specifications.key?("max_memory_size") && specifications.key?("integrated_video_support")
      errors.add(:specifications, "Especificações inválidas para placa-mãe.")
    end

    unless specifications["supported_cpu_brands"].is_a?(Array)
      errors.add(:specifications, "Especificações inválidas para placa-mãe: 'supported_cpu_brands' deve ser do tipo 'array'.")
    end

    unless specifications["max_memory_slots"].is_a?(Integer)
      errors.add(:specifications, "Especificações inválidas para placa-mãe: 'max_memory_slots' deve ser do tipo 'int'.")
    end

    unless specifications["max_memory_size"].is_a?(Integer)
      errors.add(:specifications, "Especificações inválidas para placa-mãe: 'max_memory_size' deve ser do tipo 'int'.")
    end

    unless [true, false].include?(specifications["integrated_video_support"])
      errors.add(:specifications, "Especificações inválidas para placa-mãe: 'integrated_video_support' deve ser 'true' ou 'false'.")
    end
  end

  def validate_memory_specifications
    unless specifications.present? && specifications.key?("available_sizes") && specifications["available_sizes"].is_a?(Array) && specifications["available_sizes"].all? { |size| size.is_a?(Integer) }
      errors.add(:specifications, "Especificações inválidas para memória: 'available_sizes' é obrigatório e deve ser do tipo 'array'.")
    end
  end

  def validate_gpu_specifications
    if specifications.present?
      errors.add(:specifications, "Especificações inválidas para GPU.")
    end
  end
end
