mkdir -p old

color() {
  local color="\e[3${1}m"
  local reset="\e[0m"

  shift

  if [[ "${COLOR}" == "never" ]]; then
    echo -en "${@}"
  else
    echo -en "${color}${@}${reset}"
  fi
}

log_prefix() {
  echo -n "::"
}

die() {
  error ${@}
  exit 1
}

error() {
  echo "$(color 1 "$(log_prefix) ERROR:") ${@}"
}

warn() {
  echo "$(color 3 "$(log_prefix) WARN:") ${@}"
}

info() {
  echo "$(color 2 "$(log_prefix)") ${@}"
}

#[[ -z $(git status -s) ]] || die "The working tree is dirty. Please make sure it is clean before running."

set -x

tempdir=$(mktemp -d)
trap "{ rm -rf ${tempdir}; }" EXIT

for tag in $(git tag --list); do
  git checkout ${tag}
  cp README.md $tempdir/${tag}.md
done

cp -rf $tempdir old
