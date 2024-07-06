### Build Your Computer

### Requirements
  - Ruby 3.3.0
  - Rails 7.1.3.2
  - Node
  - Git

### Commands
  - Cloning and accessing the repository:
    ```bash
    git clone https://github.com/RenanMMaciel/coreplan-developer-challenge.git && cd coreplan-developer-challenge
    ```

  - Accessing the API folder, configuring database.yml, installing dependencies, creating a database, running migrates and seeds, and starting the API on port 3000.
    ```bash
    cd build-your-computer-api/ && cp config/database.yml.example config/database.yml && bundle install && rails db:create && rails db:migrate && rails db:seed && rails s
    ```

  - Go back to the coreplan-developer-challenge folder by starting another terminal.

  - Accessing the FRONT folder, installing dependencies and starting FRONT on port 3001.
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
