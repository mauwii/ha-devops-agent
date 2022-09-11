#!/command/with-contenv bashio

# Install user configured/requested packages
if bashio::config.has_value 'install_packages'; then
    apt update \
        || bashio::exit.nok 'Failed updating Ubuntu packages repository indexes'

    for package in $(bashio::config 'install_packages'); do
        apt-get install -y "$package" \
            || bashio::exit.nok "Failed installing package ${package}"
    done
fi

# Executes user configured/requested commands on startup
if bashio::config.has_value 'init_commands'; then
    while read -r cmd; do
        eval "${cmd}" \
            || bashio::exit.nok "Failed executing init command: ${cmd}"
    done <<< "$(bashio::config 'init_commands')"
fi