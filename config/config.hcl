ui = true
disable_mlock = true

## storage "consul" {
##   # address = "127.0.0.1:8500"
##   address = "consul-agent-1:8500"
##   path = "vault/"
##   scheme = "http"
##   # redirect_addr = "http://127.0.0.1:8200"
##   # VAULT_ADDR = "http://127.0.0.1:8200"
## }

storage "file" {
 path = "vault/data"
}

listener "tcp" {
 address     = "127.0.0.1:8200"
 tls_disable = 1
}