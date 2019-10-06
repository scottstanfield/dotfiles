#!/usr/bin/bash 
# vim:filetype=sh:

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

[[ "${__usage+x}" ]] || read -r -d '' __usage <<-'EOF' || true
  -v               Enable verbose mode, print script as it is executed
  -d --debug       Enables debug mode
  -s --src   [arg] Source folder of PDFs to process. Required.
  -o --csv   [arg] CSV filename destination. Required.
  -t --temp  [arg] Use this temporary folder for intermediate steps
  -r --random  [arg] Leaving this here for Default. Default="/tmp/bar"
  -h --help        This page
  -n --no-color    Disable color output
EOF

[[ "${__helptext+x}" ]] || read -r -d '' __helptext <<-'EOF' || true
 This is Bash3 Boilerplate's help text. Feel free to add any description of your
 program or elaborate more on command-line arguments. This section is not
 parsed and will be added as-is to the help.
EOF

source bash3bp.sh

## Pre-conditions

[[ "${arg_s:-}" ]]     || help      "Set the source folder of PDFs to process with -s or --src"
[[ -d "${arg_s:-}" ]]  || help     "${arg_s} directory not found "
[[ "${arg_o:-}" ]]     || help      "Set the destination CSV filename with -c or --csv"
[[ "${LOG_LEVEL:-}" ]] || emergency "Cannot continue without LOG_LEVEL. "

hash java 2>&- || die 'need java in path'

T="${arg_t}"

# If use didn't specify -t for a temp folder, then we create one and remove at end
if [[ -z "${arg_t}" ]]; then
	T=$(mktemp --directory --tmpdir=. )
	info "Making temp folder $T"
fi

# Make the user specified folder if it doesn't exist
if [[ "${arg_t}" &&  ! -d "${arg_t}" ]]; then
	info "Making temp folder: ${arg_t}"
	mkdir "${arg_t}"
fi

### Cleanup
function __cleanup_before_exit () {
  EXIT_CODE=$?
  info "Cleaning up"

  # Only cleanup temp folder if mktemp made it
  if [[ -z "${arg_t}" ]]; then
	info "Cleaning up. Removing $T"
	[[ $T ]] && [[ -d $T ]] && rm -rf $T
  fi

  exit $EXIT_CODE
}
trap __cleanup_before_exit TERM INT QUIT EXIT

function variables () {
	info "__i_am_main_script: ${__i_am_main_script}"
	info "__file: ${__file}"
	info "__dir: ${__dir}"
	info "__base: ${__base}"
	info "OSTYPE: ${OSTYPE}"

	info "arg_s: ${arg_s}"
	info "arg_o: ${arg_o}"
	info "arg_v: ${arg_v}"
	info "arg_h: ${arg_h}"
	info "arg_t: ${arg_t}"
}


### Runtime
##############################################################################

#variables
info "Starting"

SRC_PDF=${arg_s}
DST_CSV=${arg_o}

# for i in ${SRC_PDF}/*.pdf; do
# 	base=$(basename $i .pdf)
# 	echo $base
# 	java -jar tabula.jar --pages 2,3 --guess --lattice --silent $i 2> /dev/null | tee ${DST_CSV}/$base.csv
# done

# dos2unix ${DST_CSV}

info "tmp folder: $T"
mkdir $T/step2
for i in ${T}/*.csv; do
	base=$(basename $i .csv)
	sed -n '/PASSENGERS/,/""$/p' $i | tail -n +4 | head -n -1 > $T/step2/$base.csv
done

exit 0
