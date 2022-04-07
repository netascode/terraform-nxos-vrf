resource "nxos_rest" "l1PhysIf" {
  dn         = "sys/intf/phys-[${var.id}]"
  class_name = "l1PhysIf"
  content = {
    id    = var.id
    descr = var.description
    mode  = var.mode
  }
}
