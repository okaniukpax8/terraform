resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = "${var.region}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "main" {
  name                 = "main"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.2.0/24"
}

#resource "azurerm_network_interface" "main" {
#  name                = "${var.prefix}-nic"
#  location            = "${azurerm_resource_group.main.location}"
#  resource_group_name = "${azurerm_resource_group.main.name}"
#  network_security_group_id = "${azurerm_network_security_group.main.id}"
#  ip_configuration {
#    name                          = "homework-configuration"
#    subnet_id                     = "${azurerm_subnet.internal.id}"
#    private_ip_address_allocation = "Dynamic"
#    public_ip_address_id          = "${azurerm_public_ip.main.id}"
#  }
#}
resource "azurerm_public_ip" "main" {
  name                    = "${var.prefix}-pip"
  location                = "${azurerm_resource_group.main.location}"
  resource_group_name     = "${azurerm_resource_group.main.name}"
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.main.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.5"
    public_ip_address_id          = "${azurerm_public_ip.main.id}" 
  }
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-neworkresources"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_network_security_rule" "main" {
  name                        = "test123"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.main.name}"
  network_security_group_name = "${azurerm_network_security_group.main.name}"
}
