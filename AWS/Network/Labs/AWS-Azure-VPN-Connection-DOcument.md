Create a ADserver(ADserver) in Azure, make it as DC and configure domain and other details.
Create a windows server(winserver) in AWS, add the IP of ADserver(Azure) to the DNS of this winserver.
Now we need to add this winserver in aws to ADserver domain in the Azure using VPN connection.
## VPN cofiguration:
- create Virtual Private Gateway and attach it to the winserver VPC.
- Create Virtual Network Gateway in the Azure VNet(create a gateway subnet to place this VNGW), creation of VNGW takes 20-30 mins.
- Create Customer Gateway in aws and use the IP of the VNGW in this CGW creation.
- Create Site-to-Site VPN connection in AWS using the CGW created and provide the VNET CIDR range(Azure) - routing option must be static, then it asks us to provide CIDR.
- Create LOcal network Gateway in the Azure, this is similar to CGW in AWS, in creation of this we need the IPs of the TUNNEL provided in the Site-to-site VPN connection of the AWS. SO, we need to create 2 LNGWs, 2 are provided for redundancy. Also, need to provide the AWS CIDR range here in address space
- Finally, we need to create the VPN connection in Azure(Under Virtual network Gateway) and need to select the LNGW 1&2 created previously and provide the pre-shared keys for each tunnel IP.(under site-to-site VPN connection, we get option to DOWNLOAD CONFIGURATION, in that we find these keys for both tunnels provided by AWS.
- After creation of this VPN connection on Azure end, the tunnels will still not be up as we don't have any route added in the route table of the AWS VPC.
- SO, we need to add the route with the VNET CIDR range and need to select the Virtual Private Gateway here.
- Now, tunnels will be up and we can start adding the winserver to the ADserver domain and access the server using domain creds.

