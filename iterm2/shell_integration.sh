# append them in .bashrc or .bash_profile or 

send_iterms2_user_variable() {
	#printf "\\033]1337;CurrentDir=%s\\007" $(echo -n $(pwd))
	#printf "\e]1337;CurrentDir=\w\a"

	local _iterm2_hostname="${iterm2_hostname}"
	if [ -z "${iterm2_hostname:-}" ]; then
		_iterm2_hostname=$(hostname -f 2>/dev/null)
	fi

	#iterm2_begin_osc
	#printf "1337;RemoteHost=%s@%s" "$USER" "$_iterm2_hostname"
	#iterm2_end_osc

	printf "\e]1337;SetUserVar=%s=%s\a" hostname $(echo -n ${_iterm2_hostname} | base64 -w0)
	printf "\e]1337;SetUserVar=%s=%s\a" path $(echo -n $(pwd) | base64 -w0)
}


# my own command for iTerms2
if [[ -n "$PROMPT_COMMAND" ]]; then
    PROMPT_COMMAND+=$'\n'
fi;
export PROMPT_COMMAND+="send_iterms2_user_variable"
