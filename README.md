### Build Your Computer

### Requirements
  - [Git](https://git-scm.com/downloads)
  - [Ruby 3.3.0](https://www.ruby-lang.org/en/downloads/)
  - [Rails 7.1.3.2](https://rubyonrails.org/)
  - [PostgreSQL](https://www.postgresql.org/download/)
  - [Node.js](https://nodejs.org/en/download/package-manager)

### Commands
  - Cloning and accessing the repository:
    ```bash
    git clone https://github.com/RenanMMaciel/coreplan-developer-challenge.git && cd coreplan-developer-challenge
    ```

  - Accessing the API folder, configuring database.yml, installing dependencies, creating a database, running migrates and seeds, and starting the API on port 3000.
    - In the database.yml file, you should put the username and password of the postgres user.
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
    - | Método  | Rota               | Descrição                         |
      |---------|--------------------|-----------------------------------|
      | GET     | `/components`      | Retorna uma lista de componentes. |
      | POST    | `/components`      | Cria um novo componente.          |
      | PUT     | `/components/{id}` | Atualiza um componente específico.|
      | DELETE  | `/components{id}`  | Remove um componente específico.  |
      - JSON Example
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

  - Orders `/orders`
    - | Método  | Rota           | Descrição                     |
      |---------|----------------|-------------------------------|
      | GET     | `/orders`      | Retorna uma lista de pedidos. |
      | POST    | `/orders`      | Cria um novo pedido.          |
      | PUT     | `/orders/{id}` | Atualiza um pedido específico.|
      | DELETE  | `/orders/{id}`  | Remove um pedido específico.  |
      - JSON Example
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
