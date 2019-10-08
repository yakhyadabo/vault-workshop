ui = true
disable_mlock = true

storage "consul" {
  address = "consul-agent-1:8500"
  path = "vault"
  scheme = "http"
}

storage "file" {
 path = "vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}