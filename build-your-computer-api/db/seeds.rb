# db/seeds.rb
ActiveRecord::Base.connection.execute("TRUNCATE TABLE components RESTART IDENTITY")

components = [
  {
    name: "Core i5",
    component_type: "cpu",
    specifications: {
      brand: "Intel"
    }
  },
  {
    name: "Core i7",
    component_type: "cpu",
    specifications: {
      brand: "Intel"
    }
  },
  {
    name: "Ryzen 5",
    component_type: "cpu",
    specifications: {
      brand: "AMD"
    }
  },
  {
    name: "Ryzen 7",
    component_type: "cpu",
    specifications: {
      brand: "AMD"
    }
  },
  {
    name: "Asus ROG",
    component_type: "motherboard",
    specifications: {
      supported_cpu_brands: ["Intel"],
      max_memory_slots: 2,
      max_memory_size: 16,
      integrated_video_support: false
    }
  },
  {
    name: "Gigabyte Aorus",
    component_type: "motherboard",
    specifications: {
      supported_cpu_brands: ["AMD"],
      max_memory_slots: 2,
      max_memory_size: 16,
      integrated_video_support: false
    }
  },
  {
    name: "ASRock Steel Legend",
    component_type: "motherboard",
    specifications: {
      supported_cpu_brands: ["Intel", "AMD"],
      max_memory_slots: 2,
      max_memory_size: 16,
      integrated_video_support: true
    }
  },
  {
    name: "Kingston HyperX",
    component_type: "memory",
    specifications: {
      available_sizes: [4, 8, 16, 32, 64]
    }
  },
  {
    name: "EVGA GeForce RTX 2060 6GB",
    component_type: "gpu",
    specifications: {}
  },
  {
    name: "Asus ROG Strix GeForce RTX 3060 6GB",
    component_type: "gpu",
    specifications: {}
  },
  {
    name: "Gigabyte Radeon RX 6600 XT EAGLE 8GB",
    component_type: "gpu",
    specifications: {}
  }
]

components.each do |component_data|
  Component.create!(
    name: component_data[:name],
    component_type: Component.component_types[component_data[:component_type]],
    specifications: component_data[:specifications]
  )
end
