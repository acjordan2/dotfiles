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
  local cn="localhost" size=2048 output_path="/tmp"
  local expiration=365
  local usage="openssl-generate-certificate [-n localhost] [-s 2048] [-x 365] [-p /tmp]

-n    common name
-s    key size
-x    expiration time in days
-p    output path"

  optspec="n:s:x:p:h"

  while getopts "${optspec}" opt; do
    case "${opt}" in
      n) cn="${OPTARG}";;
      s) size="${OPTARG}";;
      x) expiration="${OPTARG}";;
      p) output_path="${OPTARG}";;
      h) echo "${usage}"; return;;
    esac
  done
  
  local dir="${output_path}/${cn}"
  mkdir -p "${dir}"
  openssl req -nodes -newkey "rsa:${size}" -keyout "${dir}/key.pem" -x509 -days "${expiration}" -out "${dir}/certificate.pem" -subj "/CN=${cn}"  -passout pass:
  echo key="${dir}/key.pem"
  echo cert="${dir}/certificate.pem"
}

# Connecting to a server (Ctrl C exits)
function openssl-client () {
    openssl s_client -status -connect "${1}"
}

# Start a TLS enabled HTTP server
function openssl-server(){

  local cert key cn=localhost port=8443 web
  local optspec="k:c:p:n:hw"
  local usage="openssl-server [-k <path/to/key.pem] [-c /path/to/cert.pem] [-c localhost] [-p 8443] [-w]"

  while getopts "${optspec}" opt; do
    case "${opt}" in
      c) cert="${OPTARG}";;
      k) key="${OPTARG}";;
      n) cn="${OPTARG}";;
      p) port="${OPTARG}";;
      w) web="-WWW";;
      h) echo "${usage}"; return;;
    esac
  done

  if [[ -z "${cert}" ]] && [[ -z "${key}" ]]; then
    echo "[*] Generating self signed certificate for ${cn}"
    eval $(openssl-generate-certificate -n "${cn}" 2>/dev/null)
  fi

  if [[ -z "${cert}" && -n "${key}" ]] || 
    [[ -z "${key}" && -n "${cert}" ]]; then
    echo "openssl-server: error: both key and cert need to be set. leave both empty to generate a new key/certificate pair" >&2
    return 1
  fi

  local hpkp=$(openssl-key-to-hpkp-pin "${key}")
 
  echo "[*] Listening on ${port}. Connect via "
  echo "curl -k --pinnedpubkey 'sha256//${hpkp}' 'https://${cn}:${port}'"
  echo ""
  echo ""

  openssl s_server -key "${key}" -cert "${cert}" -accept "${port}" ${web} -msg
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
    openssl rsa -in "${1}" -outform der -pubout 2>/dev/null | openssl dgst -sha256 -binary | openssl enc -base64
}

# For setting up public key pinning (directly from the site)
function openssl-website-to-hpkp-pin() {
    echo "Q" | openssl s_client -connect "${1}" 2>/dev/null | openssl x509 -pubkey -noout | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -binary | openssl enc -base64
}

# Combines the key and the intermediate in a unified PEM file
# (eg, for nginx)
function openssl-key-and-intermediate-to-unified-pem() {
    echo -e "$(cat "${1}")\n$(cat "${2}")" > "${1:0:-4}"_unified.pem
}

