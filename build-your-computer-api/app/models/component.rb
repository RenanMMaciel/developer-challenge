class Component < ApplicationRecord
  enum component_type: { cpu: 0, motherboard: 1, memory: 2, gpu: 3 }
end
