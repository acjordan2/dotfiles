# mostly grabbed from https://expeditedsecurity.com/blog/openssl-shortcuts/
# with a few of my own shortcuts

function openssl-view-certificate () {
    openssl x509 -text -noout -in "${1}"
}

function openssl-view-csr () {
    openssl req -text -noout -verify -in "${1}"
}

function openssl-view-key () {
    openssl rsa -check -in "${1}"
}

function openssl-view-pkcs12 () {
    openssl pkcs12 -info -in "${1}"
}

# create a self signed certificate
function openssl-generate-certificate() {
  local project="${1}"
  mkdir -p "/tmp/${project}"
  openssl req -nodes -newkey rsa:2048 -keyout "/tmp/${project}/key.pem" -x509 -days 365 -out "/tmp/${project}/certificate.pem" -subj "/CN=${project}"  -passout pass:
  echo key="/tmp/${project}/key.pem"
  echo cert="/tmp/${project}/certificate.pem"
}

# Connecting to a server (Ctrl C exits)
function openssl-client () {
    openssl s_client -status -connect "${1}"
}

# Start a TLS enabled HTTP server
function openssl-server(){

  local cert key cn=localhost port=8443
  local optspec="k:c:p:n:h"
  local usage="openssl-server [-k <path/to/key.pem] [-c /path/to/cert.pem] [-p 8443]"

  while getopts "${optspec}" opt; do
    case "${opt}" in
      c) cert="${OPTARG}";;
      k) key="${OPTARG}";;
      n) cn="${OPTARG}";;
      p) port="${OPTARG}";;
      h) echo "${usage}"; return;;
    esac
  done

  if [[ -z "${cert}" ]] && [[ -z "${key}" ]]; then
    echo "[*] Generating self signed certificate for ${cn}"
    eval $(openssl-generate-certificate "${cn}")
  fi

  if [[ -z "${cert}" && -n "${key}" ]] || 
    [[ -z "${key}" && -n "${cert}" ]]; then
    echo "openssl-server: error: both key and cert need to be set. leave both empty to generate a new key/certificate pair" >&2
    return 1
  fi
  
  echo "[*] Listening on ${port}"
  openssl s_server -key "${key}" -cert "${cert}" -accept "${port}" -WWW
}

# Convert PEM private key, PEM certificate and PEM CA certificate (used by nginx, Apache, and other openssl apps) to a PKCS12 file (typically for use with Windows or Tomcat)
function openssl-convert-pem-to-p12 () {
    openssl pkcs12 -export -inkey "${1}" -in "${2}" -certfile ${3} -out ${4}
}

# Convert a PKCS12 file to PEM
function openssl-convert-p12-to-pem () {
    openssl pkcs12 -nodes -in "${1}" -out "${2}"
}

# Convert a crt to a pem file
function openssl-crt-to-pem() {
    openssl x509 -in "${1}" -out "${1:0:-4}".pem -outform PEM
}

# Check the modulus of a certificate (to see if it matches a key)
function openssl-check-certificate-modulus {
    openssl x509 -noout -modulus -in "${1}" | shasum -a 256
}

# Check the modulus of a key (to see if it matches a certificate)
function openssl-check-key-modulus {
    openssl rsa -noout -modulus -in "${1}" | shasum -a 256
}

# Check the modulus of a certificate request
function openssl-check-key-modulus {
    openssl req -noout -modulus -in "${1}" | shasum -a 256
}

# For setting up public key pinning
function openssl-key-to-hpkp-pin() {
    openssl rsa -in "${1}" -outform der -pubout | openssl dgst -sha256 -binary | openssl enc -base64
}

# For setting up public key pinning (directly from the site)
function openssl-website-to-hpkp-pin() {
    openssl s_client -connect "${1}":443 | openssl x509 -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
}

# Combines the key and the intermediate in a unified PEM file
# (eg, for nginx)
function openssl-key-and-intermediate-to-unified-pem() {
    echo -e "$(cat "${1}")\n$(cat "${2}")" > "${1:0:-4}"_unified.pem
}

