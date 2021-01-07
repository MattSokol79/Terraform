# Load Balancing
## What is Load Balancing?

![](img/load_balancer.png)

- Load balancing refers to efficiently distributing incoming network traffic acrrs a group of backend servers, also known as a server farm or pool. 
- A load balancer acts as the "traffic cop" sitting in front of the servers and routing client requests across all servers capable of fulfilling those requests in a manner that maximizes speed and capacity utilization and ensures that no one server is overworked, which could degrade performance. If a single server goes down, the load balancer redirects traffic to the remaining online servers. When a new server is added to the server group, the load balancer automatically starts to send requests to it.
- It performs the following functions:
  - Distributes client requests or network load efficiently across multiple servers.
  - Ensures high availability and reliability by sending requests only to servers that are online.
  - Provides the flexibility to add or subtract servers as demand dictates

## Types of Load Balancing
- Application (HTTP)
- Network 
- Classic/Internal

### Application
- Makes routing decisions at the application layer (HTTP/HTTPS), supports parth-based routing and can route requests to one or more ports on each container instance.
- One of the oldest forms, relies on layer 7. 
- Very flexible because it allows you to form distribution decisions based on any info that comes with an HTTP address.

### Network
- Leverages the network layer information to decide where to send network traffic. 
- Relies on Layer 4
- Handles TCP/UDP traffic 
- Considered the fastest of all Load Balancers but tends to fall short when it comes to balancing the distribtuion of traffic acrros servers.

### Classic/Internal
- Nearly idential to network, but can be leveraged to balance internal infrastructure.
- Layer 4, can either work with TCP/SSL or HTTP/HTTPS

# Other
- Hardware
- Software
- Virtual

### Hardware
- Relies on physical on-premises hardware to distribute application and network traffic. These devices can handle a large volume of traffic but often carry a hefty price tag and are fairly limited in terms of flexibility. 

### Software
- Comes in two forms—commercial or open-source—and must be installed prior to use. Like cloud-based balancers, these tend to be more affordable than hardware solutions.

### Virtual
- Differs from software load balancers because it deploys the software of a hardware load balancing device on a virtual machine.