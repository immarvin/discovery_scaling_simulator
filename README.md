# discovery_scaling_simulator
the stuff to build docker image for discovery scaling simulator for xCAT

The autobuilt docker image can be found in https://hub.docker.com/r/xcat/discovery_scaling_simulator/builds/

The steps to utilize the discovery scaling simulator:
1. find a X86_64 baremetal server and install Docker engine on it.
2. create a bridge "br0" on Docker host and attach it to a physical NIC facing the xcatd on MN
````
   brctl addbr br0;brctl addif br0 eno1;ifconfig eno1 0.0.0.0;ifconfig br0 10.4.41.30/8
````
3. create route entry to make sure the bridge "br0" can access the internet
````
   ip route add default via 10.0.0.101
````
4. create a Docker network "mynet" based on the bridge "br0" created in step #2
````
   sudo docker network create --driver=bridge --gateway=10.4.41.30 --subnet=10.4.224.1/8 --ip-range=10.4.224.1/24 -o "com.docker.network.bridge.name"="br0" mynet;
````
5. pull the discovery scaling simulator docker image
````
    docker pull xcat/discovery_scaling_simulator
````
6. run a docker container with specified IP address and MAC address to simulate the scaling discovery:
````
    for i in {1..500};do docker run  -e "XCATMASTER=10.3.5.21" --network mynet   --ip 10.4.$[224+i/200].$[i%200+1] --name "node$(printf %04d $i)" --hostname "node$(printf %04d $i)"  --mac-address="00:00:00:00:$(printf %02x $[i/256]):$(printf %02x $[i%256])" --entrypoint=/bin/dodiscovery  -itd  --rm xcat/discovery_scaling_simulator; done
````

   the environment variable "XCATMASTER" specifies the IP address of MN on which xcatd is running
