/*
Copyright 2019 F5 Networks Inc.
This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = "1.13.1"
    }
  }
}


provider "bigip" {
  address = "192.168.86.33"
  username = "admin"
  password = "W3lcome098!"
}

// Using  provisioner to download and install do rpm on bigip, pass arguments as BIG-IP IP address, credentials 
// Use this provisioner for first time to download and install do rpm on bigip

resource "null_resource" "install_do" {
  provisioner "local-exec" {
    command = "./install-do-rpm.sh 192.168.86.33 admin:W3lcome098!"
  }
}


data "template_file" "init" {
  template = file("bigip.tpl")
  vars = {
    HOSTNAME = "bigip.maniak.academy"
    DNS_ADDRESS = "8.8.8.8"
    NTP_ADDRESS = "8.8.8.8"
    GUEST_PASSWORD = "W3lcome098!"
  }
}
resource "bigip_do"  "do-deploy" {
    do_json = data.template_file.init.rendered
    #depends_on = [null_resource.install_do]
}

resource "null_resource" "install_as3" {
  provisioner "local-exec" {
    command = "./install-as3-rpm.sh 192.168.86.33 admin:W3lcome098!"
    depends_on = [bigip_do.do-deploy]
  }
}