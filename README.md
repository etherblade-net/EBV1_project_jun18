# EBV1_project_jun18
EtherBlade.net Ver1 project (jun18)

The aim of “EtherBlade.net Ver1” project is to build an FPGA-based universal line-rate ethernet over IP encapsulator – the network overlay appliance that can create L2 virtual ethernet links over L3 network (EoIP, EoMPLS, VxLAN, PBB etc).

“Etherblade.net Ver1” offers VLAN support where traffic for different vlans can be encapsulated with different L3 headers. L3 headers may not just be a static headers (like it was in “Ethernet Hardware Encapsulator” project) but they also may contain dynamically derived values. For example in order to encapsulate ethernet in IPv4, the IPv4 header’s “checksum” field must be dynamically calculated.

This functionality implemented in “Etherblade.net Ver1” makes encapsulator “universal” – be capable of supporting every possible encapsulation protocol.
Please watch this video explaining operational principles of the system followed by the demonstration of the working hardware:

https://www.youtube.com/watch?v=QCqwg6KuyCg
