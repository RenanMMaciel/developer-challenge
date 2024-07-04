import React, { useEffect, useState } from 'react';
import './OrderList.css';

const OrderList = () => {
  const [orders, setOrders] = useState([]);

  useEffect(() => {
    const fetchOrders = async () => {
      try {
        const response = await fetch('http://localhost:3000/orders');
        if (!response.ok) {
          throw new Error('Erro ao buscar pedidos');
        }
        const data = await response.json();
        setOrders(data);
      } catch (error) {
        console.error('Erro ao buscar pedidos: ', error);
      }
    };

    fetchOrders();
  }, []);

  return (
    <div className="order-list-container">
      <h2>Orders Placed</h2>
      <ul>
        {orders.map((order, index) => (
          <li key={index} className="order-item">
            <p>Order #{order.id}</p>
            <div className="order-details">
              <p>Processor ID: {order.components && order.components.cpu_id || ''}</p>
              <p>Motherboard ID: {order.components && order.components.motherboard_id || ''}</p>
              {order.components && order.components.memories && (
                <div>
                  <p>Memories</p>
                  {order.components.memories.map((memory, memIndex) => (
                    <div key={memIndex}>
                      <p>Memory ID: {memory.memory_id}</p>
                      <p>Selected Sizes: {memory.selected_sizes.join(', ')}</p>
                    </div>
                  ))}
                </div>
              )}
              <p>Graphics Card ID: {order.components && order.components.gpu_id || ''}</p>
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default OrderList;
