# mostly grabbed from https://expeditedsecurity.com/blog/openssl-shortcuts/
# with a few of my own shortcuts
function openssl-view-certificate () {
  if [[ -z "${1}" ]]; then
    openssl x509 -text -noout
  else
    openssl x509 -text -noout -in "${1}"
  fi
}

function openssl-view-csr () {
  if [[ -z "${1}" ]]; then
    openssl req -text -noout -verify
  else 
    openssl req -text -noout -verify -in "${1}"
  fi
}

function openssl-view-key () {
  if [[ -z "${1}" ]]; then
    openssl rsa -check 
  else
    openssl rsa -check -in "${1}"
  fi
}

function openssl-view-pkcs12 () {
  if [[ -z "${1}" ]]; then
    openssl pkcs12 -info
  else
    openssl pkcs12 -info -in "${1}"
  fi
}

# gets the full certificate chain (with the -f flag)
# of a remote server
function openssl-get-server-cert() {
  usage="usage: ${0} [-p|-d] [-f] www.example.com:443"
  optspec="pdhf"
  outform="PEM"
  while getopts "${optspec}" opt; do
    case "${opt}" in
      p) outform="PEM";; 
      d) outform="DER";;
      f) chain=true;;
      h) echo "${usage}"; return ;;
    esac
  done
  shift $(($OPTIND-1))

  host="${1%%:*}"
  port="${1##*:}"

  if [[ -z "${port}" ]] || [[ "${port}" = "${host}" ]]; then
    port=443
  fi
  
  if [[ -z "${chain}" ]]; then
    openssl s_client -showcerts -servername "${host}" -connect "${host}:${port}" </dev/null 2>/dev/null | openssl x509 -outform "${outform}"
  else
    openssl s_client -showcerts -verify 5 -connect "${host}:${port}" < /dev/null 2>/dev/null | awk '/BEGIN/,/END/ {print }'
  fi
}

# Clone the certificate chain of a remote server including
# intermedaite and root certificates. Only tested on the 
# default openssl version shipped with macOS
function openssl-clone-server-cert-chain(){
  local usage="usage: ${0} [-o </ouput/directory>] www.example.com:443"
  local optspec="o:dh"
  local output_path="/tmp"
  local port CA_cert CA_key

  if [[ -n "${ZSH_VERSION}" ]]; then
    offset=0
  else
    offset=1
  fi
  
  while getopts "${optspec}" opt; do
    case "${opt}" in
      o) output_path="${OPTARG}";;
      h) echo "${usage}"; return ;;
    esac
  done
  shift $(($OPTIND-1))

  if [[ -z "${1}" ]]; then 
    echo "${usage}"
    return
  fi

  host="${1%%:*}"
  port="${1##*:}"

  if [[ -z "${port}" ]] || [[ "${port}" = "${host}" ]]; then
    port=443
  fi
  
  local dir="${output_path}/${host}"
  mkdir -p "${dir}/orig" "${dir}/clone"
  
  openssl s_client -showcerts -verify 5 -connect "${host}:${port}" < /dev/null 2>/dev/null | 
    awk '/BEGIN/,/END/{ if(/BEGIN/){a++}; out="'${dir}/orig/'"a".crt"; print >out}' 
  orig_files=( ${dir}/orig/*.crt )
  
  for ((i=${#orig_files[@]}-${offset}; i>0; i--)); do

    subject=$(openssl x509 -noout -subject -in "${orig_files[$i]}" | sed 's/subject=\ //g')
    issuer=$(openssl x509 -noout -issuer -in "${orig_files[$i]}" | sed 's/issuer=\ //g')
    serial=$(openssl x509 -noout -serial -in "${orig_files[$i]}" | sed 's/serial=//g')
    san=$(openssl x509 -noout -text -in "${orig_files[$i]}" | grep "DNS")

    if [[ -z "${CA_cert}" ]]; then
      # Sign cert is not set, so lets create a self signed cert  as the root
      openssl genrsa -out "${dir}/clone/root_${host}.key" 4096
      openssl req -sha256 -new -x509 -days 1826 -subj "${issuer}" -key "${dir}/clone/root_${host}.key" -out "${dir}/clone/root_${host}.crt"
      CA_cert="${dir}/clone/root_${host}.crt"
      CA_key="${dir}/clone/root_${host}.key"
    fi
  
    openssl genrsa -out "${dir}/clone/${i}_${host}.key" 2048
    if [[ -z "${san}" ]]; then
      openssl req -sha256 -new -subj "${subject}" -key "${dir}/clone/${i}_${host}.key" \
        -out "${dir}/clone/${i}_${host}.csr"
      openssl x509 -req -days 360 -in "${dir}/clone/${i}_${host}.csr" -CA "${CA_cert}" \
        -CAkey "${CA_key}" -set_serial "0x${serial}" -out "${dir}/clone/${i}_${host}.crt" -sha256
    else
      openssl req -sha256 -new -subj "${subject}" -key "${dir}/clone/${i}_${host}.key" \
        -out "${dir}/clone/${i}_${host}.csr" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf \
        <(printf "\n[SAN]\nsubjectAltName=${san}")) -extensions SAN
      openssl x509 -req -days 360 -in "${dir}/clone/${i}_${host}.csr" -CA "${CA_cert}" \
        -CAkey "${CA_key}" -set_serial "0x${serial}" -out "${dir}/clone/${i}_${host}.crt" -sha256 \
        -extfile  <(printf "subjectAltName=${san}")
    fi

    CA_cert="${dir}/clone/${i}_${host}.crt"
    CA_key="${dir}/clone/${i}_${host}.key"
  done
  
  cat ${dir}/clone/*.crt > "${dir}/clone/fullchain_${host}.crt"
}

# start a TLS enabled server with a cloned cert chain
function openssl-clone-server() {
  local optspec="hl:" port=8443 host 
  local usage="usage: ${0} [-l 8443] www.example.com:443"

  while getopts "${optspec}" opt; do
    case "${opt}" in
      l) port="${OPTARG}";;
      H) host="${OPTARG}";;
      h) echo "${usage}"; return ;;
    esac
  done

  shift $(($OPTIND-1))

  if [[ -z "${1}" ]]; then 
    echo "${usage}"
    return
  fi
  host="${1}"

  openssl-clone-server-cert-chain "${host}" 
  openssl-server -k "/tmp/${host}/clone/1_${host}.key" -c "/tmp/${host}/clone/fullchain_${host}.crt" -l ${port} -w
}

# view the finger printn of a give x509
# certificate
function openssl-view-fingerprint {
  if [[ -z "${1}" ]]; then
    data=$(cat <&0)
    openssl x509 -noout -fingerprint -sha256 -inform PEM 2>/dev/null <<< "${data}" || openssl x509 -noout -fingerprint -sha256 -inform DER  <<< "${data}"
  else 
    openssl x509 -noout -fingerprint -sha256 -inform PEM -in "${1}" 2>/dev/null || openssl x509 -noout -fingerprint -sha256 -inform DER -in "${1}" 2>/dev/null
  fi
}

# create a self signed certificate
function openssl-generate-certificate() {
  local cn="localhost" size=2048 output_path="/tmp"
  local expiration=365
  local usage="usage: ${0} [-n localhost] [-s 2048] [-x 365] [-o /tmp]

-n    common name
-s    key size
-x    expiration time in days
-o    output path"

  optspec="n:s:x:o:h"

  while getopts "${optspec}" opt; do
    case "${opt}" in
      n) cn="${OPTARG}";;
      s) size="${OPTARG}";;
      x) expiration="${OPTARG}";;
      o) output_path="${OPTARG}";;
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
  local optspec="k:c:l:n:hwx:"
  local usage="usage: ${0} [-k <path/to/key.pem] [-c /path/to/cert.pem] [-c localhost] [-l 8443] [-w]"

  while getopts "${optspec}" opt; do
    case "${opt}" in
      a) ca_file="${OPTARG}";;
      c) cert="${OPTARG}";;
      k) key="${OPTARG}";;
      n) cn="${OPTARG}";;
      l) port="${OPTARG}";;
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

  openssl s_server -key "${key}" -cert "${cert}" -chain -CAfile "${cert}" -accept "${port}" ${web} -msg
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
