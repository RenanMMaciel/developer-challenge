### Build Your Computer

### Requisitos
  - Ruby 3.3.0
  - Rails 7.1.3.2
  - Node
  - Git

### Comandos
  - Clonando e acesso do repositório:
    ```bash
    git clone https://github.com/RenanMMaciel/coreplan-developer-challenge.git && cd coreplan-developer-challenge
    ```

  - Acessando pasta da API, configurando database.yml, instalando dependências, criando banco, rodando migrates e seeds, e iniciando API na porta 3000.
    ```bash
    cd build-your-computer-api/ && cp config/database.yml.example config/database.yml && bundle install && rails db:create && rails db:migrate && rails db:seed && rails s
    ```

  - Volte para a pasta coreplan-developer-challenge iniciando outro terminal

  - Acessando pasta do FRONT, instalando dependências e iniciando FRONT na porta 3001
    ```bash
    cd build-your-computer-front/ && npm i && npm start
    ```

### Endpoints
  - Components `/components`
    - CPU
      ```json
      {
        "name": "Core i5",
        "component_type": "cpu",
        "specifications": {
          "brand": "Intel"
        }
      }
      ```

    - Motherboard
      ```json
      {
        "name": "Asus ROG",
        "component_type": "motherboard",
        "specifications": {
          "supported_cpu_brands": ["Intel"],
          "max_memory_slots": 2,
          "max_memory_size": 16,
          "integrated_video_support": false
        }
      }
      ```

    - Memory
      ```json
      {
        "name": "Kingston HyperX",
        "component_type": "memory",
        "specifications": {
          "available_sizes": [4, 8, 16, 32, 64]
        }
      }
      ```

    - GPU
      ```json
      {
        "name": "Evga Geforce RTX 2060 6GB",
        "component_type": "gpu",
        "specifications": {}
      }
      ```

  - Orders `/components`
    ```json
    {
      "customer_name": "Pedro",
      "components": {
        "cpu_id": 1,
        "motherboard_id": 5,
        "memories": [
            {
                "memory_id": 8,
                "selected_sizes": [
                    8
                ]
            },
            {
                "memory_id": 8,
                "selected_sizes": [
                    8
                ]
            }
        ],
        "gpu_id": 9
      }
    }
    ```
