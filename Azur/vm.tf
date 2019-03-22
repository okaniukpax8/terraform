resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_B1s"

  delete_os_disk_on_termination = true


  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "${var.vm_sku}"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "Orest"
    admin_password = "Superadmin123!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  
  provisioner "remote-exec" {
    inline = [
        "sudo apt update",
        "sudo apt-get install apache2 -y",
        "sudo rm -rf /var/www/html/index.html",
        "echo Hi DevOps Flow, my IP is $(curl https://ipinfo.io/ip) | sudo tee --append /var/www/html/index.html",
        "sudo systemctl restart apache2"
            ]
    connection {
    
      type     = "ssh"
      user     = "Orest"
      password = "Superadmin123!"

  }
  }
  tags = {
    environment = "dev"
  }
}
resource "azurerm_managed_disk" "main" {
  name                 = "${azurerm_virtual_machine.main.name}-disk1"
  location             = "${azurerm_resource_group.main.location}"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  managed_disk_id    = "${azurerm_managed_disk.main.id}"
  virtual_machine_id = "${azurerm_virtual_machine.main.id}"
  lun                = "10"
  caching            = "ReadWrite"
}