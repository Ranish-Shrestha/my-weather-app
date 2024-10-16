provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "group" {
  name     = "rg-weather-app"
  location = "East US"
  tags = {
    "Terraform" = "true"
  }
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "Vnet-weather-app"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
}

# Create Subnets for ASE and VM
resource "azurerm_subnet" "asesubnet" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "ase-subnet"
  resource_group_name  = azurerm_resource_group.group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  delegation {
    name = "Microsoft.Web.hostingEnvironments"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.Web/hostingEnvironments"
    }
  }
  depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_subnet" "vmsubnet" {
  address_prefixes     = ["10.0.2.0/24"]
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  depends_on           = [azurerm_virtual_network.vnet]
}

# Create ASE
resource "azurerm_app_service_environment_v3" "aseenv1" {
  allow_new_private_endpoint_connections = false
  internal_load_balancing_mode           = "Web, Publishing"
  name                                   = "ase-env-1"
  resource_group_name                    = azurerm_resource_group.group.name
  subnet_id                              = azurerm_subnet.asesubnet.id
  depends_on                             = [azurerm_subnet.asesubnet]
}

# Create App Service Plan
resource "azurerm_service_plan" "asp1" {
  name                       = "ase-asp-1"
  resource_group_name        = azurerm_resource_group.group.name
  location                   = azurerm_resource_group.group.location
  os_type                    = "Windows"
  sku_name                   = "I1V2"
  app_service_environment_id = azurerm_app_service_environment_v3.aseenv1.id
}

# Create Public IP and NIC for jumpbox VM
resource "azurerm_public_ip" "publicip" {
  name                = "pip-vm-jumpbox"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "interface1" {
  name                = "nic-vm-jumpbox"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}


# Create Jumpbox Virtual Machine
resource "azurerm_windows_virtual_machine" "jumpboxvm" {
  name                  = "vm-jumpbox"
  resource_group_name   = azurerm_resource_group.group.name
  location              = azurerm_resource_group.group.location
  size                  = "Standard_F2"
  admin_username        = "azureuser"
  admin_password        = "P@ssW0rdssss"
  network_interface_ids = [azurerm_network_interface.interface1.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
